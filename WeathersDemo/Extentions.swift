//
//  Extentions.swift
//  WeathersDemo
//
//  Created by Tran Chung on 6/15/17.
//  Copyright © 2017 Tran Chung. All rights reserved.
//

import UIKit
extension UIImageView {
    func dowloadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
}
extension WeatherComingTVC {
    
    func dayWeek(day: TimeInterval) -> String {
        let create = Date(timeIntervalSince1970: day)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifierCountry)
        let dayVI = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: create) - 1]
        return dayVI
    }
    
    func hourDay(hour: TimeInterval) -> String {
        let create = Date(timeIntervalSince1970: hour)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifierCountry)
        dateFormatter.timeStyle = .short
        let hourVI = dateFormatter.string(from: create)
        return hourVI
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> Int {
        let date = Date(timeIntervalSince1970: interval)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour], from: date)
        let hour = comp.hour
        return hour!
    }
}
