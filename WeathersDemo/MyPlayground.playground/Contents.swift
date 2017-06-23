//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let create =  Date(timeIntervalSince1970: 1498016155)
let dateFormatter = DateFormatter()
dateFormatter.locale = Locale(identifier: "VI")
dateFormatter.timeStyle = .short
let day = Calendar.current.component(.weekday, from: create)

let f = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: create) - 1]


