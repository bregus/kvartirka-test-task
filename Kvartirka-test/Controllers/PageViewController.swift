//
//  PageViewController.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 14.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    weak var galleryDelegate: GalleryViewControllerDelegate?

    var photos : [Photo] = []
    var aspectRatio : CGFloat = CGFloat()
    
    private(set) lazy var items: [UIViewController] = {
        var controllers: [UIViewController] = []
        for photo in photos {
            controllers.append(createGalleryItem(with: photo.url))
        }
        return controllers
    }()
    
    fileprivate func createGalleryItem(with url: String) -> UIViewController {

        let page = SmallGalleryItem(url: url, aspectRatio: aspectRatio)
        return page
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstViewController = items[0] as UIViewController? {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        galleryDelegate?.PageViewController(PageViewController: self, didUpdatePageCount: items.count)
    }
    
    
}

extension PageViewController : UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        if let firstViewController = viewControllers?.first,
            let index = items.firstIndex(of: firstViewController) {
            galleryDelegate?.PageViewController(PageViewController: self,
                    didUpdatePageIndex: index)
        }
    }
    
}

protocol GalleryViewControllerDelegate: class {
    
    func PageViewController(PageViewController: PageViewController,
        didUpdatePageCount count: Int)
    
    func PageViewController(PageViewController: PageViewController,
        didUpdatePageIndex index: Int)
    
}
