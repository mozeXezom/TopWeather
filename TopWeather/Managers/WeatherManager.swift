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
    
}
