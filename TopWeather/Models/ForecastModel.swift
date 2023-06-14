//
//  ForecastModel.swift
//  TopWeather
//
//  Created by mozeX on 13.06.2023.
//

import UIKit

struct ForecastModel: Codable {
    let city: City
    let list: [List]
    
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
}

struct List: Codable {
    let dt: Double
    let dtTxt: String
    let main: MainData
    
    var tempString: String {
        return String(format: "%.0f", main.temp) + "ºC"
    }
    
    var timeString: String {
        let date = Date(timeIntervalSince1970: dt)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        return dateFormatter.string(from: date)
        
    }
    
    var day: String {
        let date = Date(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    var date: String {
        let date = Date(timeIntervalSince1970: dt)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    var allString: String {
        return "\(day) | \(timeString) | \(date)"
    }
    
    enum CodingKeys: String, CodingKey {
        case dt
        case dtTxt = "dt_txt"
        case main
    }
}

struct MainData: Codable {
    let temp: Double
}


