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
    
    let locationManager = LocationManager()
    var weatherManager = WeatherManager()
    var name: String?
    var temp: String?
    var weatherDesc: String?
    var modelData: WeatherModel?

    func checkLocation() {
        locationManager.requestLocationAuthorization()
    }
    
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
                activity.stopAnimating()
                
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
                activity.stopAnimating()
            }
        }
    }
    
}



