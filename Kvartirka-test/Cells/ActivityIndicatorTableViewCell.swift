//
//  ActivityIndicatorTableViewCell.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 15.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit

class ActivityIndicatorTableViewCell: UITableViewCell {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
