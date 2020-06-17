//
//  FlatTableViewCell.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 12.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit

class FlatTableViewCell: UITableViewCell {

    @IBOutlet weak var flatImage: ImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var cost: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(address: String, cost: String, image: String) {
        self.address.text = address
        self.cost.text = cost
        self.flatImage.setImage(from: image)
        flatImage.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
