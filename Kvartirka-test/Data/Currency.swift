//
//  Currency.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 13.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import Foundation

struct Currency{
    var id: Int
    var name: String
    var label: String
    
    init(id: Int, name: String, label: String) {
        self.id = id
        self.name = name
        self.label = label
    }
}

