//
//  WeatherData.swift
//  Clima
//
//  Created by Mohamed Jaber on 11/23/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit

struct WeatherData: Decodable{//Decodable(JSON->Swift), but Encodable(Swift->JSON), There is something that compines the use of the two is (Codable)
    
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
}
struct Main: Codable{
    let temp: Double
    let humidity: Double
}
struct Weather: Decodable{
    let description: String
    let id: Int
}
struct Wind: Decodable{
    let speed: Double
}
