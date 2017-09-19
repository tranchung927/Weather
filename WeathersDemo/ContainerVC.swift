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
    
    @IBOutlet weak var imageWeather: UIImageView!
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
        imageWeather.loadGif(name: "rain")
        locationManager.delegate = self
        registerNotification()
        startNotifier()
        Reach().monitorReachabilityChanges(host: "google.com")
    }
    
    func startNotifier() {
        NotificationCenter.default.addObserver(self, selector: #selector(alertInternet), name: ReachabilityStatusChangedNotification, object: nil)
    }
    // Alert Internet
    func alert(isConnect: Bool) {
        let controller = UIAlertController(title: "No Internet Detected", message: "This app requires an Internet connection", preferredStyle: .alert)
        if isConnect == false {
            locationManager.stopUpdatingLocation()
            present(controller, animated: true, completion: nil)
        } else {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
            dismiss(animated: true, completion: nil)
        }
    }
    // Check status internet
    func alertInternet() {
        let status = Reach().connnectionStatus()
        
        switch status {
        case .online(.wifi):
            print("Connected WiFi")
            alert(isConnect: true)
        case .online(.wwan):
            print("Connected WWAN")
        case .offline, .unknow:
            print("Not connected")
            alert(isConnect: false)
        }
    }
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationKey.data, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            if error == nil {
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                // City
                if let city = placeMark.addressDictionary?["City"] as? String {
                    let trimmedString = city.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
//                    let cityCurrent = ConverHelper.convertVietNam(trimmedString)
                    guard let cityCurrent = trimmedString.asciiString else { return }
                    DataServices.shared.searchKey = cityCurrent
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                    print(trimmedString)
                }
                // Country
                if let country = placeMark.addressDictionary?["Country"] as? NSString {
                    print(country)
                }
            }
            manager.stopUpdatingLocation()
        })
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
