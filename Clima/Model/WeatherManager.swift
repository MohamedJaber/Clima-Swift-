//
//  WeatherManager.swift
//  Clima
//
//  Created by Mohamed Jaber on 11/23/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    let weatherURL="https://api.openweathermap.org/data/2.5/weather?appid=7168e0b2634972aaf920373242bd4012&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String){
        let urlString="\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude:CLLocationDegrees){
        let urlString="\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    func performRequest(with urlString: String){//External name first, Enternal name second
        if let url=URL(string: urlString){
            let session=URLSession(configuration: .default)
            let task=session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData=data{
                    let weather=self.parseJSON(safeData)
                    self.delegate?.didUpdateWeather(weather: weather!)
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ weatherData: Data)->WeatherModel?{
        let decoder=JSONDecoder()
        do{
            let decodedData=try decoder.decode(WeatherData.self, from: weatherData)
            let name=decodedData.name
            let temp=decodedData.main.temp
            let id=decodedData.weather[0].id
            let description=decodedData.weather[0].description
            let humidity=decodedData.main.humidity
            let speed=decodedData.wind.speed
            let weather=WeatherModel(cityName: name, conditionID: id, temperature: temp, humidity: humidity, windSpeed: speed, description: description)
            return weather
            //print(weather.conditionName)
        }catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
