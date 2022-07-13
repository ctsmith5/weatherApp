//
//  LocationViewModel.swift
//  WeatherApp1
//
//  Created by Colin Smith on 7/9/22.
//

import Foundation
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    /// Obtain User Location
    ///
    /// Parameters:
    ///
    ///  - None
    ///
    /// Completes With:
    ///
    ///  - Latitude / Longitute String
    ///
    func requestLocation(completion: @escaping (String) -> Void ) {
        
        if CLLocationManager.locationServicesEnabled(), locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        }
        guard let location = locationManager?.location?.coordinate else { return }
        let lat = String(describing: location.latitude)
        let long = String(describing:location.longitude)
        
        completion(lat+","+long)
        
    }
    
    
   private func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break // We're good to go, don't need to check anything else
        case .denied, .restricted:
            //show alert about needing location
            print("You need to enable location services for this app to work")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default :
            print(locationManager.authorizationStatus)
        }
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
}
