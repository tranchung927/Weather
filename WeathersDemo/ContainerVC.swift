//
//  ViewController.swift
//  WeathersDemo
//
//  Created by Tran Chung on 6/12/17.
//  Copyright © 2017 Tran Chung. All rights reserved.
//

import UIKit
import CoreLocation

class ContainerVC: UIViewController {
    @IBOutlet weak var degreeLB: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var conditonLb: UILabel!
    
    var locationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        return locationManager
    }()
    
    var weather: WeatherForecast? {
        willSet {
            self.weather = DataServices.shared.weatherForecasts
        }
        didSet{
            nameLb.text = self.weather?.city
            guard let degree = self.weather?.degreeCurrent else {
                return
            }
            degreeLB.text = "\(degree)ºC"
            conditonLb.text = weather?.conditionCurrent
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        registerNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationKey.data, object: nil)
    }
    func updateData() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        self.weather = DataServices.shared.weatherForecasts
    }
}

extension ContainerVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // City
            if let city = placeMark.addressDictionary?["City"] as? String {
                let trimmedString = city.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                let cityCurrent = ConverHelper.convertVietNam(trimmedString)
                DataServices.shared.searchKey = cityCurrent
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                print(trimmedString)
            }
            
            // Country
            if let country = placeMark.addressDictionary?["Country"] as? NSString {
                print(country)
            }
            manager.stopUpdatingLocation()
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
