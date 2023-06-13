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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        setupUI()
        setupSearchBar()
        setupTableView()
        viewModel.checkLocation()
        
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

    @IBAction func locationBtnPressed(_ sender: UIButton) {
        viewModel.checkLocation()
        activityIndicator.startAnimating()
    }
}

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        searchBar.endEditing(true)
    }
}


extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellsId.weatherCell, for: indexPath) as! WeatherTableViewCell
        return cell
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            manager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        displaySimpleAlert(title: "Error!", message: "Something went wrong. Please try again.", activityIndicator: activityIndicator)
    }
}

