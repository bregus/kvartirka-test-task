//
//  Flat.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 12.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import Foundation
import UIKit

enum BuildingType {
    case flat
    case cottage
}

struct Flat {
    var id : Int?
    var city_id : Int?
    var buildingType : BuildingType?
    var rooms: Int?
    var address : String?
    var description : String?
    var priceDay : Int?
    var priceNight : Int?
    var priceHour : Int?
    var photoDefault : Photo?
    var contacts : Contacts?
    var photos : [Photo]?
    var title : String?
}

struct Contacts {
    var id : Int
    var flats_count : Int
    var name : String
    var skype : String
    var vk_profile : String
    var send_booking_request_allowed : Bool
    var show_prepayment_warning : Bool
    var phones : [String]
}

struct Photo {
    var url : String
    var verified : Bool
    var aspectRatio : CGFloat?
}

struct Badges {
    var ownerConfirmed : Bool
    var moreThanYear : Bool
    var payed : Int
}
