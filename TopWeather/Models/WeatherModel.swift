//
//  WeatherModel.swift
//  TopWeather
//
//  Created by mozeX on 13.06.2023.
//

import Foundation
import UIKit

struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let name: String
    let wind: Wind
    
    var temperatureString: String {
        return String(format: "%.0f", main.temp) + "ºC"
    }
    
    var descriptionString: String {
        return weather[0].main
    }
    
    var feelsLikeString: String {
        return String(format: "%.0f", main.feels_like) + "ºC"
    }
    
    var pressureString: String {
        return "\(main.pressure) hPa"
    }
    
    var humidityString: String {
        return "\(main.humidity)%"
    }
    
    var visibilityString: String {
        return "\(visibility)m"
    }
    
    var windSpeedString: String {
        return String(format: "%.0f", wind.speed) + "m/s"
    }
    
    var windDirectionString: String {
        return "\(wind.deg)deg"
    }
   
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}
