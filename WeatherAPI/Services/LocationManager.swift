//  LocationManager.swift
//  WeatherAPI
//  Created by Irina Arkhireeva on 18.05.2025.

import Foundation
import CoreLocation

/// Делегат для уведомлений о результатах получения геолокации
protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithLocation(error: Error?)
}

/// Менеджер для работы с геолокацией пользователя
class LocationManager: NSObject {
    private let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        manager.delegate = self
    }
    func requestLocationAccess() {
        manager.requestWhenInUseAuthorization()
    }
    
    func fetchLocation() {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // Пользователь запретил доступ или доступ ограничен
            let error = NSError(domain: "LocationManager", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Доступ к геолокации запрещен"
            ])
            delegate?.didFailWithLocation(error: error)
        @unknown default:
            delegate?.didFailWithLocation(error: nil)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            let error = NSError(domain: "LocationManager", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Доступ к геолокации был отозван"
            ])
            delegate?.didFailWithLocation(error: error)
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            delegate?.didUpdateLocation(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude
            )
        } else {
            let error = NSError(domain: "LocationManager", code: 3, userInfo: [
                NSLocalizedDescriptionKey: "Не удалось получить координаты"
            ])
            delegate?.didFailWithLocation(error: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithLocation(error: error)
    }
}
