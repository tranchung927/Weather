// //
////  Weather.swift
////  WeathersDemo
////
////  Created by Tran Chung on 6/14/17.
////  Copyright © 2017 Tran Chung. All rights reserved.
////
//
//import Foundation
//
//typealias JSON = Dictionary<AnyHashable,Any>
//
//struct CityWeather {
//    var degree: Double
//    var condition: String
//    var imgURL: String
//    var city: String
//    var timeCurrent: TimeInterval
//    var weatherOfDays: [WeatherOfDay] = []
//    
//    
//    init?(json: JSON) {
//        guard let location = json["location"] as? JSON,
//            let name = location["name"] as? String
//            else {
//                return nil
//        }
//        guard let current = json["current"] as? JSON,
//            let temp = current["temp_c"] as? Double,
//            let last_updated_epoch = current["last_updated_epoch"] as? TimeInterval
//            else {
//                return nil
//        }
//        guard let condition = current["condition"] as? JSON,
//            let text = condition["text"] as? String,
//            let icon = condition["icon"] as? String
//            else {
//                return nil
//        }
//        
//        guard let forecast = json["forecast"] as? JSON,
//            let forecastdays = forecast["forecastday"] as? [JSON]
//            else {
//                return nil
//        }
//        for dayWeatherDict in forecastdays {
//            if let weatherOfDay = WeatherOfDay(json: dayWeatherDict) {
//                weatherOfDays.append(weatherOfDay)
//            }
//        }
//        
//        // Initialize properties
//        self.city = name
//        self.condition = text
//        self.degree = temp
//        self.imgURL = "http:\(icon)"
//        self.timeCurrent = last_updated_epoch
//    }
//}
//
//class WeatherOfHour {
//    var time_Hour: TimeInterval
//    var tempC_Hour: Double
//    var icon_Hour: String
//    
//    init?(json: JSON) {
//        //            for item in hour! {
//        //                let time_Hour = item["time_epoch"] as? TimeInterval
//        //                let tempC_Hour = item["temp_c"] as? Double
//        //                let condition_Hour = item["condition"] as? JSON
//        //                let icon_Hour = condition_Hour?["icon"] as? String
//        //                let weatherObject = WeatherOfHour(timeHour: time_Hour!, tempCHour: tempC_Hour!, iconHour: "http:\(icon_Hour!)")
//        //                weatherObjectarray.append(weatherObject)
//        //
//        //                print(weatherObjectarray.count)
//        //            }
//        //            let weatherDateObject = WeatherOfDay(date: date_epoch!, iconDate: iconDay, maxtemp: maxtemp_c, mintemp: mintemp_c)
//        //            weatherDateObjectArray.append(weatherDateObject)
//
//    }
//}
//class WeatherOfDay {
//    var date: TimeInterval
//    var icon_Date: String
//    var maxtemp_Date: Double
//    var mintemp_Date: Double
//    var weatherOfHours: [WeatherOfHour]?
//    
//    init?(json: JSON) {
//        
//        for hourWeatherJSON in hourWeatherJSONs{
//            if let weatherOfHour = WeatherOfHour(json: hourWeatherJSON) {
//                weatherOfHours?.append(weatherOfHour)
//            }
//        }
////        let date_epoch = item_D["date_epoch"] as? TimeInterval
////        guard let day = item_D["day"] as? JSON,
////            let maxtemp_c = day["maxtemp_c"] as? Double,
////            let mintemp_c = day["mintemp_c"] as? Double,
////            let conditionDay = day["condition"] as? JSON
////            else {
////                return nil
////        }
////        guard let iconDay = conditionDay["icon"] as? String
////            else {
////                return nil
////        }
////        let hour = item_D["hour"] as? [JSON]
//    }
//}
