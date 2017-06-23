//
//  DataServices.swift
//  WeathersDemo
//
//  Created by Tran Chung on 6/14/17.
//  Copyright © 2017 Tran Chung. All rights reserved.
//  http://api.apixu.com/v1/forecast.json?key=19c25d79bf234b12af0101146171206&q=Paris
//  http://api.apixu.com/v1/forecast.json?key=f3d902b438a3451c92605731171906&q=Hanoi&days=10

import UIKit

class DataServices {
    static let shared : DataServices = DataServices()
    
    var searchKey: String = "" {
        didSet {
            weatherAtLocation(locationString: searchKey)
        }
    }
    var weatherForecasts: WeatherForecast?
    
    private func  weatherAtLocation(locationString: String) {
        let baseUrl = "http://api.apixu.com/v1/forecast.json?&days=7"
        var urlString = baseUrl
        var parameter : Dictionary<String, String> = [:]
        parameter["q"] = searchKey
        parameter["key"] = "f3d902b438a3451c92605731171906"
        
        for (key,value) in parameter {
            urlString += "&" + key + "=" + value
            print(urlString)
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        makeDataTaskRequest(request: urlRequest){
            self.weatherForecasts = WeatherForecast(json: $0)
            NotificationCenter.default.post(name: NotificationKey.data, object: nil)
        }
    }

    
    private func makeDataTaskRequest(request: URLRequest, completedBlock: @escaping (JSON) -> Void ) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonObject =  try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {
                return
            }
            guard let json = jsonObject as? JSON else {
                return
            }
            DispatchQueue.main.async {
                completedBlock(json)
            }
        }
        task.resume()
    }
}
