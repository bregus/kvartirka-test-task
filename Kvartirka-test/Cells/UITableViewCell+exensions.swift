//
//  UITableViewCell+exensions.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 12.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}

extension UITableViewCell {
    
    static func register(for tableView: UITableView) {
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
}
