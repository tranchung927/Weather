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
extension TimeInterval {
    
    func dayWeek(identifier: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: identifier)
        return dateFormatter.string(from: date)
    }
    
    func hourDay(identifier: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: identifier)
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
extension String {
    var asciiString: String? {
        if let data = self.data(using: String.Encoding.ascii, allowLossyConversion: true){
            return String.init(data: data, encoding: String.Encoding.ascii)
        }
        return nil
    }
}
