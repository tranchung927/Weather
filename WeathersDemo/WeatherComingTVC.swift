//
//  TableViewController.swift
//  WeathersDemo
//
//  Created by Tran Chung on 6/21/17.
//  Copyright © 2017 Tran Chung. All rights reserved.
//

import UIKit

class WeatherComingTVC: UITableViewController {
    @IBOutlet var dayOfWeekCell: [UILabel]!
    @IBOutlet var iconCell: [UIImageView]!
    @IBOutlet var maxDegreeCell: [UILabel]!
    @IBOutlet var minDegreeCell: [UILabel]!
    
    @IBOutlet weak var maxDegree: UILabel!
    @IBOutlet weak var minDegree: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var colectionView: UICollectionView!
    
    var identifierCountry = "VI"
    var weatherDay: WeatherOfDay? {
        willSet {
            self.weatherDay = DataServices.shared.weatherForecasts?.weatherOfDays[0]
        }
        didSet{
            let dayCurrent = weatherDay?.date ?? 0
            dayOfWeek.text = dayWeek(day: dayCurrent)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationKey.data, object: nil)
    }

    func updateData() {
        colectionView.reloadData()
//        print(getHour().count)
        self.weatherDay = DataServices.shared.weatherForecasts?.weatherOfDays[0]
            maxDegree.text = "\(weatherDay?.maxTemp_Date ?? 0)"
            minDegree.text = "\(weatherDay?.minTemp_Date ?? 0)"
        for index in 0..<dayOfWeekCell.count {
            
            guard let date = DataServices.shared.weatherForecasts?.weatherOfDays[index+1].date else {
                return
            }
            dayOfWeekCell[index].text = dayWeek(day: date)
            
            guard let icon = DataServices.shared.weatherForecasts?.weatherOfDays[index+1].icon_Date else {
                return
            }
            iconCell[index].downloadImage(from: icon)
            
            guard let temMax = DataServices.shared.weatherForecasts?.weatherOfDays[index+1].maxTemp_Date else {
                return
            }
            maxDegreeCell[index].text = "\(temMax)"
            
            guard let temMin = DataServices.shared.weatherForecasts?.weatherOfDays[index+1].minTemp_Date else {
                return
            }
            minDegreeCell[index].text = "\(temMin)"
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return colectionView
    }
//    func getHour() -> Array<Any>{
//        let hoursOfDay = DataServices.shared.weatherForecasts?.weatherOfDays[0].weatherOfHours ?? []
//        var b: [Int] = []
//        for i in hoursOfDay{
//            let a = stringFromTimeInterval(interval: i.time_Hour)
//            b.append(a)
//        }
//        let timeCurren = stringFromTimeInterval(interval: weatherDay?.date ?? 0)
//        return b.filter {$0 > timeCurren}
//    }
}
extension WeatherComingTVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataServices.shared.weatherForecasts?.weatherOfDays[0].weatherOfHours.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeatherHourCell
        if let weather = DataServices.shared.weatherForecasts?.weatherOfDays[0].weatherOfHours[indexPath.row] {
                let str = hourDay(hour: weather.time_Hour)
                cell.degree.text = "\(weather.tempC_Hour)ºC"
                cell.time.text = "\(str)"
                cell.item.downloadImage(from: weather.icon_Hour)
        }
        return cell
    }
}

