//
//  UIImage+extension.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 13.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ImageView : UIImageView {
        
    var imageUrlString : String?
    
    func setImage(from url: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        
        imageUrlString = url
        
        image = #imageLiteral(resourceName: "placeholder.png")
        
        if let imageFromCache = imageCache.object(forKey: url as NSString) {
            image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                if self?.imageUrlString == url {
                    self?.image = image
                }
                imageCache.setObject(image, forKey: url as NSString)
            }
        }.resume()
    }
    
}

