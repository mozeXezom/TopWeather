//
//  WeatherManager.swift
//  TopWeather
//
//  Created by mozeX on 13.06.2023.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case badUrl, badParse
}

struct WeatherManager {
    
    let baseUrl = APIConfig.baseUrl + APIConfig.apiKey
    let castUrl = APIConfig.foreCastUrl
    let baseCastUrl = APIConfig.baseCastUrl
    let cityUrl = APIConfig.cityCastUrl
    
    func fetchLocationData(latitude: CLLocationDegrees, longitude: CLLocationDegrees,
                           completion: @escaping (Result<WeatherModel, Error>) -> ()
    )  {
        let locUrl = "\(baseUrl)&lat=\(latitude)&lon=\(longitude)"
        let encodedUrlString = locUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedUrlString ?? locUrl)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _,error in
            if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchCityData(city: String,
                       completion: @escaping (Result<WeatherModel, Error>) -> ()
    )  {
        let cityUrl = "\(baseUrl)&q=\(city)"
        let encodedUrlString = cityUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedUrlString ?? cityUrl)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _,error in
            if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchForecastData(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (Result<ForecastModel, Error>) -> ()
    ) {
        let forecastUrl = "\(baseCastUrl)\(latitude)&lon=\(longitude)&cnt=80&appid=\(APIConfig.apiKey)&units=metric"
        let url = URL(string: forecastUrl)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _,error in
            if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(ForecastModel.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func fetchForecastCityData(city: String, completion: @escaping (Result<ForecastModel, Error>) -> ()
    ) {
        let forecastUrl = "\(cityUrl)\(city)&cnt=80&appid=\(APIConfig.apiKey)&units=metric"
        let encodedUrlString = forecastUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedUrlString ?? forecastUrl)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _,error in
            if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(ForecastModel.self, from: data)
                    completion(.success(result))
                } catch {
                    print(error)
                    print("WRTFFF")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}
