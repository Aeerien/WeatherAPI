//  WeatherModels.swift
//  WeatherAPI
//  Created by Irina Arkhireeva on 18.05.2025.

import Foundation

// MARK: - Models for Weather API responses

/// Модель текущей погоды с локацией
struct CurrentWeather: Codable {
    let location: Location
    let current: Current
}

/// Модель ответов с прогнозом
struct ForecastResponse: Codable {
    let forecast: Forecast
}

/// Прогноз на несколько дней
struct Forecast: Codable {
    let forecastday: [Day]
}

/// Погода на один день
struct Day: Codable {
    let date: String
    let day: DayWeather
    let hour: [Hour]
}

/// Почасовые данные
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

/// Суточный прогноз
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

/// Текущая погода
struct Current: Codable {
    let tempCelsius: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case tempCelsius = "temp_c"
        case condition
    }
}

/// Локация
struct Location: Codable {
    let name: String
}

/// Условие погоды
struct Condition: Codable {
    let text: String
    let icon: String
}
