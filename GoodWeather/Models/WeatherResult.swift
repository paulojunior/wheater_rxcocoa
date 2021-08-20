//
//  WeatherResukt.swift
//  GoodWeather
//
//  Created by Junior Ferreira on 20/08/21.
//

import Foundation


struct WeatherResult: Decodable {
    let main: Weather
}


struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
