//
//  ViewController.swift
//  foodie
//
//  Created by Andi Setiyadi on 6/11/18.
//  Copyright © 2018 devhubs. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Save Restaurants List", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField {  (textField: UITextField) in
            textField.placeholder = "Name"
            textField.text = ""
        }
        
        let defaultAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { [weak self] (action: UIAlertAction) in
            guard let name = alertController.textFields?[0].text else { return }
            
            self?.foodieService.saveCurrentList(withName: name)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    var locationManager: CLLocationManager?
    var userLocation: CLLocation?
    private var foodieService = FoodieService.shared
    private var restaurants = [Restaurant]()
    var places = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LocationService.shared.locationUpdateHandler = { [weak self] (needUpdate: Bool, userLocation: CLLocation?) in
            if needUpdate {
                self?.fetchRestaurantList()
            }
            else {
                DispatchQueue.main.async {
                    if let currentPlaces = self?.foodieService.places, currentPlaces.count > 0 {
                        self?.places = currentPlaces
                        self?.tableView.reloadData()
                    }
                    else {
                        self?.fetchRestaurantList()
                    }
                }
            }
        }
        
        LocationService.shared.findUserLocation()
    }
    
    private func fetchRestaurantList() {
        foodieService.loadRestaurants(around: userLocation) { [weak self] (arrPlaces: [Place]?) in
            if let arrPlaces = arrPlaces {
                DispatchQueue.main.async {
                    self?.places = arrPlaces
                    self?.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RestaurantViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RestaurantTableViewCell
        
        if let place = places[indexPath.row] as? Place {
            OperationQueue().addOperation { [weak self] in
                if let imageURLStr = (self?.places[indexPath.row] as? Place)?.placeInfo.thumbImage,
                    let url = URL(string: imageURLStr),
                    let imageData = NSData(contentsOf: url) {
                    let image = UIImage(data: imageData as Data)
                    
                    DispatchQueue.main.async {
                        cell.thumbImageView.image = image
                    }
                }
            }
            
            cell.nameLabel.text = place.placeInfo.name
            cell.addressLabel.text = place.placeInfo.location.address
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
}

