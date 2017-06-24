//
//  Weather7Days.swift
//  Weather
//
//  Created by Admin on 6/23/17.
//  Copyright © 2017 Apple Inc. All rights reserved.
//

import Foundation

typealias JSON = Dictionary<AnyHashable, Any>

struct WeatherForecast {
    var degreeCurrent: Double
    var conditionCurrent: String
    var imageURLCurrent: String
    var city: String
    var timeCurrent: TimeInterval
    var weatherOfDays: [WeatherOfDay] = []
    
    init?(json: JSON) {
        
        guard let location = json["location"] as? JSON,
            let nameCity = location["name"] as? String
        else {
            return nil
        }
        
        guard let current = json["current"] as? JSON,
            let tempCurrent = current["temp_c"] as? Double,
            let last_updated_epoch = current["last_updated_epoch"] as? TimeInterval
        else {
            return nil
        }
        
        guard let condition = current["condition"] as? JSON,
            let conditionTextCurrent = condition["text"] as? String,
            let conditionIconCurrent = condition["icon"] as? String
        else {
            return nil
        }
        
        guard let forecast = json["forecast"] as? JSON,
            let forecastDays = forecast["forecastday"] as? [JSON]
        else {
            return nil
        }
        
        for forecastDay in forecastDays {
            if let weatherDay = WeatherOfDay(json: forecastDay) {
                weatherOfDays.append(weatherDay)
            }
        }
        
        self.city = nameCity
        self.degreeCurrent = tempCurrent
        self.conditionCurrent = conditionTextCurrent
        self.imageURLCurrent = "http:\(conditionIconCurrent)"
        self.timeCurrent = last_updated_epoch
    }
}

class WeatherOfDay {
    var date: TimeInterval
    var icon_Date: String
    var maxTemp_Date: Double
    var minTemp_Date: Double
    var weatherOfHours: [WeatherOFHour] = []
    
    init?(json: JSON) {

        guard let dateEpoch = json["date_epoch"] as? TimeInterval else {
            return nil
        }
        
        guard let day = json["day"] as? JSON,
            let tempMax = day["maxtemp_c"] as? Double,
            let tempMin = day["mintemp_c"] as? Double
        else {
            return nil
        }
        
        guard let conditionDay = day["condition"] as? JSON,
            let iconDay = conditionDay["icon"] as? String
        else {
            return nil
        }
        
        guard let hoursOfDay = json["hour"] as? [JSON] else {
            return nil
        }
        
        for hourOfDay in hoursOfDay {
            if let weatherHour = WeatherOFHour(json: hourOfDay) {
             weatherOfHours.append(weatherHour)
            }
        }
        
        self.date = dateEpoch
        self.icon_Date = "http:\(iconDay)"
        self.maxTemp_Date = tempMax
        self.minTemp_Date = tempMin
    }
}

class WeatherOFHour {
    
    var time_Hour: TimeInterval
    var tempC_Hour: Double
    var icon_Hour: String
    
    init?(json: JSON) {
        
        guard let hourEpoch = json["time_epoch"] as? TimeInterval else {
            return nil
        }
        
        guard let tempHour = json["temp_c"] as? Double else {
            return nil
        }
        
        guard let conditionHour = json["condition"] as? JSON,
            let iconHour = conditionHour["icon"] as? String
        else {
            return nil
        }
        
        self.time_Hour = hourEpoch
        self.tempC_Hour = tempHour
        self.icon_Hour = "http:\(iconHour)"
    }
}
