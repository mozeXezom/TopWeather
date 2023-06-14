//
//  ViewController.swift
//  TopWeather
//
//  Created by mozeX on 13.06.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var weatherDescLbl: UILabel!
    @IBOutlet weak var feelsLikeLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    
    var viewModel: WeatherViewModel = WeatherViewModel()
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var location: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageUserLocation()
        setupUI()
        setupSearchBar()
        setupTableView()
        
    }
    
    private func setupUI() {
        backgroundImgView.image = UIImage(named: "back_bg")
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        weatherTableView.allowsSelection = false
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(UINib(nibName: CellsName.weatherCellName, bundle: nil), forCellReuseIdentifier: CellsId.weatherCell)
    }
    
    func manageUserLocation(){
        activityIndicator.startAnimating()
        location = CLLocationManager()
        location?.delegate = self
        location?.allowsBackgroundLocationUpdates = true
        location?.requestAlwaysAuthorization()
        location?.startUpdatingLocation()
    }

    @IBAction func locationBtnPressed(_ sender: UIButton) {
        manageUserLocation()
        activityIndicator.startAnimating()
    }
}

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        if let city = searchBar.text {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            viewModel.getCityWeather(cityName: city, controller: self, activity: activityIndicator) { model in
                DispatchQueue.main.async {
                    self.cityLbl.text = model.name
                    self.tempLbl.text = model.temperatureString
                    self.weatherDescLbl.text = model.descriptionString
                    self.feelsLikeLbl.text = model.feelsLikeString
                    self.pressureLbl.text = model.pressureString
                    self.windSpeedLbl.text = model.windSpeedString
                    self.humidityLbl.text = model.humidityString
                    self.activityIndicator.stopAnimating()
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            viewModel.getForecastCityWeather(cityName: city, controller: self, activity: activityIndicator) { model in
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                }
            }
            dispatchGroup.notify(queue: .main) {
                print("done")
            }
        }
        self.searchBar.endEditing(true)
        searchBar.text = ""
        activityIndicator.startAnimating()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "City name..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchBar.text {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            viewModel.getCityWeather(cityName: city, controller: self, activity: activityIndicator) { model in
                DispatchQueue.main.async {
                    self.cityLbl.text = model.name
                    self.tempLbl.text = model.temperatureString
                    self.weatherDescLbl.text = model.descriptionString
                    self.feelsLikeLbl.text = model.feelsLikeString
                    self.pressureLbl.text = model.pressureString
                    self.windSpeedLbl.text = model.windSpeedString
                    self.humidityLbl.text = model.humidityString
                    self.activityIndicator.stopAnimating()
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            viewModel.getForecastCityWeather(cityName: city, controller: self, activity: activityIndicator) { model in
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                }
            }
            dispatchGroup.notify(queue: .main) {
              
                print("done")
            }
        }
        
        searchBar.text = ""
        activityIndicator.startAnimating()
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.forecastData?.list == nil {
            return 0
        } else {
            return (viewModel.forecastData?.list.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsId.weatherCell, for: indexPath) as! WeatherTableViewCell
        let dateList = viewModel.forecastData?.list[indexPath.row]
        cell.dayLbl.text = dateList?.allString
        cell.tempLbl.text = dateList?.tempString
        return cell
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            viewModel.getLocationWeather(lat: latitude, long: longitude, controller: self, activity: activityIndicator) { model in
                DispatchQueue.main.async {
                    self.cityLbl.text = model.name
                    self.tempLbl.text = model.temperatureString
                    self.weatherDescLbl.text = model.descriptionString
                    self.feelsLikeLbl.text = model.feelsLikeString
                    self.pressureLbl.text = model.pressureString
                    self.windSpeedLbl.text = model.windSpeedString
                    self.humidityLbl.text = model.humidityString
                    //manager.stopUpdatingLocation()
                    self.activityIndicator.stopAnimating()
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.enter()
            viewModel.getForecastWeather(lat: latitude, long: longitude, controller: self) { model in
                DispatchQueue.main.async {
                    print(model.list)
                    self.weatherTableView.reloadData()
                    
                
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
              
                print("done")
            }

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location")
        //displayAlert(title: "Error!", message: "Something went wrong. Please try again.")
    }
}

