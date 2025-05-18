//  WeatherServiceError.swift
//  WeatherAPI
//  Created by Irina Arkhireeva on 18.05.2025.

import Foundation

/// Ошибки сервиса WeatherService с описаниями для пользователя
enum WeatherServiceError: LocalizedError {
    case invalidURL
    case requestFailed(errorCode: Int)
    case noData
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Некорректный адрес для получения данных о погоде."
        case .requestFailed(let errorCode):
            return "Сервер вернул ошибку (код \(errorCode)). Попробуйте позже."
        case .noData:
            return "Сервер не прислал данные."
        case .decodingError:
            return "Не удалось обработать данные от сервера."
        }
    }
}
