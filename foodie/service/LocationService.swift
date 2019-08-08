//
//  LocationService.swift
//  foodie
//
//  Created by Andi Setiyadi on 6/11/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    static let shared = LocationService()
    private override init() {}
    
    var locationUpdateHandler: ((Bool, CLLocation?) -> Void)?
    
    var userLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    func findUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        print(CLLocationManager.authorizationStatus().rawValue)
        
        if  CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        locationManager.stopUpdatingLocation()
        
        if userLocation == nil || userLocation!.distance(from: lastLocation) > 100.0 {
            userLocation = lastLocation
            locationUpdateHandler?(true, userLocation)
        }
        else  {
            locationUpdateHandler?(false, userLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
