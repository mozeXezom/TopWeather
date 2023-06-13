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
    
    var viewModel: WeatherViewModel = WeatherViewModel()
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var location: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageUserLocation()
        activityIndicator.startAnimating()
        setupUI()
        setupSearchBar()
        setupTableView()
        //viewModel.checkLocation()
        
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
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(UINib(nibName: CellsName.weatherCellName, bundle: nil), forCellReuseIdentifier: CellsId.weatherCell)
    }
    
    func manageUserLocation(){
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
        searchBar.endEditing(true)
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
            viewModel.getCityWeather(cityName: city, controller: self, activity: activityIndicator) { model in
                DispatchQueue.main.async {
                    self.cityLbl.text = model.name
                    self.tempLbl.text = model.temperatureString
                    self.weatherDescLbl.text = model.descriptionString
                    self.activityIndicator.stopAnimating()
                }
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
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsId.weatherCell, for: indexPath) as! WeatherTableViewCell
        return cell
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            print(latitude + longitude)
            viewModel.getLocationWeather(lat: latitude, long: longitude, controller: self, activity: activityIndicator) { model in
                DispatchQueue.main.async {
                    self.cityLbl.text = model.name
                    self.tempLbl.text = model.temperatureString
                    self.weatherDescLbl.text = model.descriptionString
                    manager.stopUpdatingLocation()
                    self.activityIndicator.stopAnimating()
                }
            }

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        displayAlert(title: "Error!", message: "Something went wrong. Please try again.")
    }
}

