//
//  SmallGalleryItem.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 14.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit

class SmallGalleryItem: UIViewController {
    
    
    init(url: String, aspectRatio: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        let imageView = ImageView()
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / aspectRatio)
        
        view.addSubview(imageView)
        imageView.setImage(from: url)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
