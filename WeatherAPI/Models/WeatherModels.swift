
import Foundation

// MARK: - Models for Weather API responses

struct CurrentWeather: Codable {
    let location: Location
    let current: Current
}

struct ForecastResponse: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [Day]
}

struct Day: Codable {
    let date: String
    let day: DayWeather
    let hour: [Hour]
}

struct Hour: Codable {
    let time: String
    let tempCelsius: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case time
        case tempCelsius = "temp_c"
        case condition
    }
}

struct DayWeather: Codable {
    let maxTempCelsius: Double
    let minTempCelsius: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTempCelsius = "maxtemp_c"
        case minTempCelsius = "mintemp_c"
        case condition
    }
}

struct Current: Codable {
    let tempCelsius: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case tempCelsius = "temp_c"
        case condition
    }
}

struct Location: Codable {
    let name: String
}

struct Condition: Codable {
    let text: String
    let icon: String
}
