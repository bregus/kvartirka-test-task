//
//  API.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 12.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import Foundation
import UIKit

class API {
    
    static var APIAddress = "http://api.kvartirka.com/client/1.4"
    
    struct Requests {
        static var countires = "/country/"
        static var flats = "/flats/"
    }
    
    static var deviceOS : String = {
        return UIDevice.current.systemVersion
    }()
    
    static var appVersion : String = {
        return "ios-" + (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")
    }()
    
    static var clientID : String = {
        var clinetId = UserDefaults.standard.object(forKey: "clientId") as! String?
        
        if (clinetId == nil) {
            clinetId = UUID().uuidString
            UserDefaults.standard.set(clinetId, forKey: "clientId")
            UserDefaults.standard.synchronize()
        }
        return clinetId!
    }()
    
    static var deviceID : String = {
       return UIDevice.current.identifierForVendor!.uuidString
    }()
    
    static func GetFlats(meta: QueryMeta, compeltion: @escaping ((_ meta: QueryMeta, _: Bool)->Void)) {
        Request(address: APIAddress + Requests.flats + "?offset=\(meta.offset)&device_screen_width=\(UIScreen.main.bounds.width)&currency_id=\(General.currentCurrency.id)&city_id=\(General.currentCity)") { (data) in
            let query = data["query"] as! [String:Any]
            let metaRaw = query["meta"] as! [String:Any]
            let meta = QueryMeta(offset: metaRaw["offset"] as! Int, nearest: metaRaw["nearest"] as! Int, limit: metaRaw["limit"] as! Int)
            for flatRaw in data["flats"] as! [[String:Any]] {
                let prices = flatRaw["prices"] as! [String:Any]
                let photoDef = flatRaw["photo_default"] as! [String:Any]
                let aspectRatio = (photoDef["width"] as! CGFloat) / (photoDef["height"] as! CGFloat)
                let photosRaw = flatRaw["photos"] as! [[String:Any]]
                var photos = [Photo]()
                for photo in photosRaw {
                    photos.append(Photo(url: photo["url"] as! String, verified: (photo["verified"] != nil)))
                }
                let buildingType : BuildingType = (flatRaw["building_type"] as! String) == "flat" ? BuildingType.flat : BuildingType.cottage
                
                let flat = Flat(id: flatRaw["id"] as? Int, city_id: flatRaw["city_id"] as? Int, buildingType: buildingType, rooms: flatRaw["rooms"] as? Int, address: flatRaw["address"] as? String, description: flatRaw["description"] as? String, priceDay: prices["day"] as? Int , priceNight: prices["night"] as? Int, priceHour: prices["hour"] as? Int, photoDefault: Photo(url: (photoDef["url"] as! String), verified: (photoDef["verified"] != nil), aspectRatio: aspectRatio), contacts: nil, photos: photos, title: flatRaw["title"] as? String)
                General.currentSession.flats.append(flat)
            }
            var isEndOfList = false
            if (meta.limit > (data["flats"] as! [[String:Any]]).count) {
                isEndOfList = true
            }
            compeltion(meta,isEndOfList)
        }
    }
    
    static func GetCountries (compeltion: @escaping (()->Void)) {
        Request(address: APIAddress + Requests.countires) { (data) in
            for currencyRaw in data["currencies"] as! [[String:Any]] {
                let currency = Currency(id: currencyRaw["id"] as! Int, name: currencyRaw["name"] as! String, label: currencyRaw["label"] as! String)
                General.currentSession.currencies.append(currency)
            }
            for countryRaw in data["countries"] as! [[String:Any]] {
                var cities : [City] = [City]()
                for cityRaw in countryRaw["cities"] as! [[String:Any]] {
                    cities.append(City(id: cityRaw["id"] as! Int, name: cityRaw["name"] as! String, countryId: cityRaw["country_id"] as! Int, latitude: (cityRaw["coordinates"] as! [String:Any])["lat"] as! Double, longitude: (cityRaw["coordinates"] as! [String:Any])["lon"] as! Double))
                }
                let country = Country(id: countryRaw["id"] as! Int, name: countryRaw["name"] as! String, cities: cities, currencyDefaultId: countryRaw["currency_default_id"] as! Int)
                General.currentSession.countries.append(country)
            }
            compeltion()
        }
    }
    
    static func Request(address: String, method: String = "GET", completion: @escaping (([String: Any]) -> Void)) {
        let req = NSMutableURLRequest(url: NSURL(string: address)! as URL);
        req.httpMethod = method
        req.addValue(appVersion, forHTTPHeaderField: "X-ApplicationVersion")
        req.addValue(clientID, forHTTPHeaderField: "X-Client-ID")
        req.addValue(deviceID, forHTTPHeaderField: "X-Device-ID")
        req.addValue(deviceOS, forHTTPHeaderField: "X-Device-OS")
        
        URLSession.shared.dataTask(with: req as URLRequest) {data, response, err in
            if err != nil {
                return
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                        completion(json)
                    }
                } catch _ {
                }
            }
        }.resume()
    }
}

struct QueryMeta {
    var offset: Int
    var nearest: Int
    var limit: Int
}
