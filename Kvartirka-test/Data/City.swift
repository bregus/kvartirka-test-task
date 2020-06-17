//
//  City.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 13.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import Foundation
import CoreLocation

struct City {
    var id: Int
    var countryId: Int
    var name: String
    var coordinates: CLLocation
    
    init(id: Int, name: String, countryId: Int, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.countryId = countryId
        self.coordinates = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
}

