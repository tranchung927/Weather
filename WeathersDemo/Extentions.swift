//
//  Extentions.swift
//  WeathersDemo
//
//  Created by Tran Chung on 6/15/17.
//  Copyright © 2017 Tran Chung. All rights reserved.
//

import UIKit
extension UIImageView {
    func downloadImage(from url: String) {
        let urlRrquest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRrquest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
}
