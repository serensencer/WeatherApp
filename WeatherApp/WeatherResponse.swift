//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Seren Sencer on 10.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import Foundation

struct WeatherResponse: Codable {
    
    struct Coordinate: Codable {
        let lat: Double?
        let lon: Double?
    }
    
    struct Weather: Codable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct Main: Codable {
        let temp: Double?
        let pressure: Double?
        let humidity: Double?
        let tempMin: Double?
        let tempMax: Double?
        let seaLevel: Double?
        let grndLevel: Double?
        
        enum CodingKeys : String, CodingKey {
            case temp
            case pressure
            case humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct Wind: Codable {
        let speed: Double?
        let deg: Double?
    }
    
    struct Clouds: Codable {
        let all: Double?
    }
    
    struct Rain: Codable {
        let h1: Double?
        let h3: Double?
        
        enum CodingKeys : String, CodingKey {
            case h1 = "1h"
            case h3 = "3h"
        }
    }
    
    struct Snow: Codable {
        let h1: Int?
        let h3: Int?
        
        enum CodingKeys : String, CodingKey {
            case h1 = "1h"
            case h3 = "3h"
        }
    }
    
    struct Sys: Codable {
        let type: Int?
        let id: Int?
        let message: Double?
        let country: String?
        let sunrise: Date?
        let sunset: Date?
    }
    
    struct Element: Codable {
        let coord: Coordinate?
        let weather: [Weather]?
        let main: Main?
        let wind: Wind?
        let clouds: Clouds?
        let rain: Rain?
        let snow: Snow?
        let dt: Date?
        let sys: Sys?
        let id: Int?
        let name: String?
    }
    
    let list: [Element]?
}
