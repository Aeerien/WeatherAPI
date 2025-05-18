//  WeatherViewModel.swift
//  WeatherAPI
//  Created by Irina Arkhireeva on 18.05.2025.

import Foundation

/// Отвечает за получение данных, их обработку и уведомление ViewController об изменениях
class WeatherViewModel {
    private let weatherService = WeatherService()
    var onWeatherUpdate: (() -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    private(set) var currentWeather: CurrentWeather?
    private(set) var hourlyForecast: [Hour] = []
    private(set) var dailyForecast: [Day] = []
    
    /// Текущие координаты (по умолчанию Москва)
    private var latitude: Double = 55.7558
    private var longitude: Double = 37.6176
    
    func setLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        fetchWeather()
    }
    
    func fetchWeather() {
        onLoadingStateChange?(true)
        let group = DispatchGroup()
        
        group.enter()
        weatherService.fetchCurrentWeather(lat: latitude, lon: longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let current):
                self.currentWeather = current
            case .failure(let error):
                self.onError?(error)
            }
            group.leave()
        }
        
        group.enter()
        weatherService.fetchForecast(lat: latitude, lon: longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                let allHours = forecast.forecast.forecastday.flatMap { $0.hour }
                let startIdx = self.currentHourIndex()
                let endIdx = min(allHours.count, startIdx + 24)
                self.hourlyForecast = Array(allHours[startIdx..<endIdx])
                self.dailyForecast = forecast.forecast.forecastday
            case .failure(let error):
                self.onError?(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.onLoadingStateChange?(false)
            self?.onWeatherUpdate?()
        }
    }
    
    private func currentHourIndex() -> Int {
        Calendar.current.component(.hour, from: Date())
    }
}
