//
//  ViewController.swift
//  Kvartirka-test
//
//  Created by Рома Сумороков on 12.06.2020.
//  Copyright © 2020 Рома Сумороков. All rights reserved.
//

import UIKit
import CoreLocation

class HomeFeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var fetchingMore = true
    var loadedToEnd = false
    let locationManager = CLLocationManager()
    var lastMeta = QueryMeta(offset: 0, nearest: 0, limit: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        FlatTableViewCell.register(for: tableView)
        ActivityIndicatorTableViewCell.register(for: tableView)

        SetUserLocationService()
    }
    
    func LoadFlats() {
        API.GetCountries() {
            General.SetCurrentCity()
            API.GetFlats(meta: self.lastMeta) { meta, end in
                DispatchQueue.main.async {
                    self.fetchingMore = false
                    self.lastMeta = meta
                    self.navigationItem.title = General.CityTitleBy(id: General.currentCity)
                    self.tableView.reloadData()
                    self.loadedToEnd = end
                }
            }
        }
    }
    
    func loadMoreFlats() {
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        API.GetFlats(meta: self.lastMeta) { meta, end in
            DispatchQueue.main.async {
                self.fetchingMore = false
                self.loadedToEnd = end
                self.lastMeta = meta
                self.tableView.reloadData()
            }
        }
    }
}

extension HomeFeedViewController : CLLocationManagerDelegate {
    func SetUserLocationService() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        LoadFlats()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            General.userLocation = location
            LoadFlats()
        }
    }
}

extension HomeFeedViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (tableView.frame.width / (General.currentSession.flats[indexPath.row].photoDefault?.aspectRatio)!) + 60
        } else if indexPath.section == 1 && General.currentSession.flats.count == 0 {
            return tableView.frame.height
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return General.currentSession.flats.count
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FlatTableViewCell.identifier) as! FlatTableViewCell
            let flat = General.currentSession.flats[indexPath.row]
            cell.setup(address: flat.address!, cost: "\(flat.priceDay!)\(General.currentCurrency.label) в сутки", image: flat.photoDefault!.url)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityIndicatorTableViewCell.identifier) as! ActivityIndicatorTableViewCell
            cell.activity.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "FlatDetailViewController") as! FlatDetailViewController
            controller.flat = General.currentSession.flats[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if !loadedToEnd {
            if offsetY > contentHeight - scrollView.frame.height + 30 {
                if !fetchingMore {
                    fetchingMore = true
                    loadMoreFlats()
                }
            }
        }
    }
    

}
