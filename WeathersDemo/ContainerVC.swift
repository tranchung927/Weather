//
//  ViewController.swift
//  WeathersDemo
//
//  Created by Tran Chung on 6/12/17.
//  Copyright © 2017 Tran Chung. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {
    @IBOutlet weak var degreeLB: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var conditonLb: UILabel!
    
    var time: Date?
    
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
extension ContainerVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DataServices.shared.searchKey = searchBar.text ?? ""
    }
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}
