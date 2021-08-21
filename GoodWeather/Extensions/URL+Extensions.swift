//
//  URL+Extensions.swift
//  GoodWeather
//
//  Created by Junior Ferreira on 21/08/21.
//

import Foundation


extension URL {
    
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=3b2b727479adc7c07db5d00f1b08d3dd&units=imperial")!
    }
}
