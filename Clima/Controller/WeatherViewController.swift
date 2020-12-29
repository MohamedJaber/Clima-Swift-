//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager=WeatherManager()
    let locationManager=CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate=self
        weatherManager.delegate=self
    }
    @IBAction func currentLocationBtn(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)//to make the keyboard disappear
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {//to assign a functionality to (go) button in the keyboard
        print(searchTextField.text!)
        searchTextField.endEditing(true)//to make the keyboard disappear
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder="Write something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {//to clear the search bar after editing
        if let city=textField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text=""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(weather: WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text=String(format: "%.0f",weather.temperature)
            self.cityLabel.text=weather.cityName
            self.conditionImageView.image=UIImage(systemName: weather.conditionName)
        }
    }
    func didFailWithError(error: Error){
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location=locations.last{
            locationManager.stopUpdatingLocation()
            let lat=location.coordinate.latitude
            let long=location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
