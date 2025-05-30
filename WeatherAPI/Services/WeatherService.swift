
import Foundation

// Service for fetching weather data from WeatherAPI
class WeatherService {
    private let baseURL = "https://api.weatherapi.com/v1/"
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    
    // Requests current weather by coordinates
    func fetchCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        let urlString = "\(baseURL)current.json?key=\(apiKey)&q=\(lat),\(lon)"
        fetch(urlString: urlString, completion: completion)
    }
    
    // Requests 7-day weather forecast by coordinates
    func fetchForecast(lat: Double, lon: Double,completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        let urlString = "\(baseURL)forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=7"
        fetch(urlString: urlString, completion: completion)
    }
    
    // Universal method for performing HTTPS requests and decoding JSON
    private func fetch<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(WeatherServiceError.invalidURL))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200..<300).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    completion(.failure(WeatherServiceError.requestFailed(errorCode: httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(WeatherServiceError.noData))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(WeatherServiceError.decodingError(error)))
                }
            }
        }.resume()
    }
}
