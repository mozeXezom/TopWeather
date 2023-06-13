//
//  Alert.swift
//  TopWeather
//
//  Created by mozeX on 13.06.2023.
//

import UIKit

extension UIViewController {
    func displaySimpleAlert(title: String, message: String, activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            activityIndicator.stopAnimating()
        }
    }
}
