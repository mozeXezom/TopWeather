//
//  WeatherViewModel.swift
//  TopWeather
//
//  Created by mozeX on 13.06.2023.
//

import Foundation

class WeatherViewModel {
    
    let locationManager = LocationManager()
    
    func checkLocation() {
        locationManager.requestLocationAuthorization()
    }
    
}
