//
//  MenuViewController.swift
//  foodie
//
//  Created by Andi Setiyadi on 6/11/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    private var userLocation: CLLocation?
    private var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findUserLocation()
    }

    @IBAction func didTapRestaurantAroundMeAction(_ sender: UIButton) {
        
    }
    
    private func findUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        
        print(CLLocationManager.authorizationStatus().rawValue)
        
        if  CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager?.startUpdatingLocation()
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRestaurant" {
            let destination = segue.destination as! RestaurantViewController
            destination.userLocation = userLocation
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        userLocation = lastLocation
        
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

