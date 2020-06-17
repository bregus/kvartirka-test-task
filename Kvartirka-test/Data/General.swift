//
//  General.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 13.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct General {
    var currencies: [Currency] = []
    var countries: [Country] = []
    var flats: [Flat] = []
    
    static var currentCity : Int = 18
    static var currentCurrency = Currency(id: 643, name: "Российский рубль", label: "р.")
    static var currentSession : General = General()
    static var userLocation: CLLocation?
    
    static func SetCurrentCity() {
        if (userLocation != nil) {
            currentCity = currentSession.ClosestCityTo(location: userLocation!)
        }
    }
    
    func ClosestCityTo(location: CLLocation) -> Int{
        var cityId = 0
        var minDist = CGFloat.infinity
        
        for country in countries {
            for city in country.cities {
                let dist = location.distance(from: city.coordinates)
                if (dist < CLLocationDistance(minDist)) {
                    cityId = city.id
                    minDist = CGFloat(dist)
                }
            }
        }
        return cityId
    }
    
    static func CityTitleBy(id: Int) -> String {
        for country in currentSession.countries {
            for city in country.cities {
                if city.id == id {
                    return city.name
                }
            }
        }
        return ""
    }
    
}
