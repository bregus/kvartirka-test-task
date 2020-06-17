//
//  FlatDetailViewController.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 14.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit
import ScrollingPageControl

class FlatDetailViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var pageControl: ScrollingPageControl!
    var flat: Flat = Flat()
    @IBOutlet weak var roomsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageGalleryHeighConstraint: NSLayoutConstraint!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        imageGalleryHeighConstraint.constant = view.frame.width / (flat.photoDefault?.aspectRatio)!
        roomsLabel.text = flat.title
        addressLabel.text = flat.address
        priceLabel.text = "\(flat.priceDay!)\(General.currentCurrency.label) в сутки"
        descriptionLabel.text = flat.description
        pageControl.dotColor = .white
        pageControl.selectedColor = .systemBlue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageGallerySegue" {
            if let pageController = segue.destination as? PageViewController{
                
                pageController.photos = flat.photos!
                pageController.aspectRatio = (flat.photoDefault?.aspectRatio)!
                pageController.galleryDelegate = self
            }
        }
    }
}

extension FlatDetailViewController: GalleryViewControllerDelegate {
    func PageViewController(PageViewController: PageViewController, didUpdatePageCount count: Int) {
        pageControl.pages = count
    }
    
    func PageViewController(PageViewController: PageViewController, didUpdatePageIndex index: Int) {
        pageControl.selectedPage = index

    }
}
