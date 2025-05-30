
import Foundation

// Errors from the WeatherService with user-friendly descriptions
enum WeatherServiceError: LocalizedError {
    case invalidURL
    case requestFailed(errorCode: Int)
    case noData
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL for fetching weather data."
        case .requestFailed(let errorCode):
            return "Server returned an error (code \(errorCode)). Please try again later."
        case .noData:
            return "No data received from the server."
        case .decodingError:
            return "Failed to process the data from the server."
        }
    }
}
