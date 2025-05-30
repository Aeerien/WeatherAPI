
import Foundation
import CoreLocation

// Delegate for receiving location update results
protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(latitude: Double, longitude: Double)
    func didFailWithLocation(error: Error?)
}

// Manager for handling user location services
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
            // The user has denied or restricted access
            let error = NSError(domain: "LocationManager", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Location access is denied"
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
                NSLocalizedDescriptionKey: "Location access has been revoked"
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
                NSLocalizedDescriptionKey: "Failed to retrieve coordinates"
            ])
            delegate?.didFailWithLocation(error: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithLocation(error: error)
    }
}
