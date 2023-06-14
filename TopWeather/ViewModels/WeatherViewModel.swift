//
//  WeatherViewModel.swift
//  TopWeather
//
//  Created by mozeX on 13.06.2023.
//

import Foundation
import CoreLocation
import UIKit

class WeatherViewModel {
    
    var weatherManager = WeatherManager()
    var modelData: WeatherModel?
    var forecastData: ForecastModel?
    
    func getCityWeather(cityName: String, controller: UIViewController, activity: UIActivityIndicatorView, completion: @escaping (WeatherModel) -> ()
    ) {
        weatherManager.fetchCityData(city: cityName) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.modelData = model
                    completion(model)
                }
            case .failure(let error):
                print(error.localizedDescription)
                controller.displayAlert(title: "Error!", message: "We can't find this city. Please try again.")
                DispatchQueue.main.async {
                    activity.stopAnimating()
                }
                
            }
        }
      
    }
    
    func getLocationWeather(lat: CLLocationDegrees, long: CLLocationDegrees, controller: UIViewController, activity: UIActivityIndicatorView, completion: @escaping (WeatherModel) -> ()
    ) {
        weatherManager.fetchLocationData(latitude: lat, longitude: long) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.modelData = model
                    completion(model)
                }
            case .failure(let error):
                print(error.localizedDescription)
                controller.displayAlert(title: "Error!", message: "Something went wrong finding your location. Please try again.")
                DispatchQueue.main.async {
                    activity.stopAnimating()
                }
            }
        }
    }
    
    func getForecastWeather(lat: CLLocationDegrees, long: CLLocationDegrees, controller: UIViewController, completion: @escaping (ForecastModel) -> ()
    ) {
        weatherManager.fetchForecastData(latitude: lat, longitude: long) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.forecastData = model
                    completion(model)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getForecastCityWeather(cityName: String, controller: UIViewController, activity: UIActivityIndicatorView, completion: @escaping (ForecastModel) -> ()
    ) {
        weatherManager.fetchForecastCityData(city: cityName) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.forecastData = model
                    completion(model)
                }
            case .failure(let error):
                controller.displayAlert(title: "Error!", message: "Something went wrong finding this city. Please try again.")
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    activity.stopAnimating()
                }
            }
        }
    }
    
}



