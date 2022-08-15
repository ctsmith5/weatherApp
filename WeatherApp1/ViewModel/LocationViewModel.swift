//
//  LocationViewModel.swift
//  WeatherApp1
//
//  Created by Colin Smith on 7/9/22.
//

import Foundation
import LocationService

class LocationViewModel: NSObject, ObservableObject {
    
    @Published var currentLocationTextString = ""
    var locationClient = LocationClient()
    var locationSearchText: String = ""
    var streetAddress = ""
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
    func requestLocation(completion: @escaping (String?) -> Void ) {
       locationClient.checkLocationServicesEnabled()
        
        
        completion(locationClient.getLocation())
    }
    
    func getStreetAddress() async {
        await self.streetAddress = locationClient.getStreetAddress()
    }
    
}
