//
//  City.swift
//  WeatherApp
//
//  Created by Seren Sencer on 14.06.2019.
//  Copyright © 2019 Seren Sencer. All rights reserved.
//

import Foundation

struct City: Codable {
    
    let id: Int?
    let name: String?
    let country: String?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.country = "TR"
    }
    
}
