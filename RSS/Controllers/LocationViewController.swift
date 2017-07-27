//
//  LocationViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/22/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//
import UIKit
import PureLayout
import DZNEmptyDataSet
import GooglePlaces
import SwiftOverlays

protocol LocationDelegate {
    func saveLocation(location: Location)
}

class LocationViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, GMSAutocompleteFetcherDelegate {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    var constraintsAdded = false
    
    var fetcher: GMSAutocompleteFetcher?
    var locations = [Location]()
    
    var locationDelegate: LocationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.clipsToBounds = true
        view.addTapToDismiss()
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = Global.colorSignin
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        title = "ADDRESS"
        
        let cancelBarButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancel))
        cancelBarButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "OpenSans-semibold", size: 15)!], for: UIControlState.normal)
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        searchBar.frame = CGRect(x: 0, y: 0, width: Global.SCREEN_WIDTH, height: 44)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search Location"
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.clear
        searchBar.barTintColor = UIColor.clear
        searchBar.tintColor = Global.colorSignin
        
        for view in searchBar.subviews {
            for subview in view.subviews {
                if subview is UITextField {
                    let textField: UITextField = subview as! UITextField
                    textField.backgroundColor = UIColor.clear
                    break
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = Global.colorSeparator
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        fetcher = GMSAutocompleteFetcher(bounds: nil, filter: filter)
        fetcher?.delegate = self
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            tableView.autoAlignAxis(toSuperviewAxis: .vertical)
            tableView.autoMatch(.width, to: .width, of: view)
            tableView.autoPinEdge(.top, to: .bottom, of: searchBar)
            tableView.autoPinEdge(toSuperviewMargin: .bottom)
        }
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No location found"
        let attrs = [NSFontAttributeName: UIFont(name: "OpenSans", size: 20),
                     NSForegroundColorAttributeName: Global.colorSignin]
        return NSAttributedString(string: text, attributes: attrs)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.location = locations[indexPath.row]
        
        cell.layoutIfNeeded()
        cell.setNeedsLayout()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let location = locations[indexPath.row]
        
        let placesClient = GMSPlacesClient.shared()
        SwiftOverlays.showBlockingWaitOverlay()
        
        placesClient.lookUpPlaceID(location.placeId!, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
      
            location.latitude = place?.coordinate.latitude
            location.longitude = place?.coordinate.longitude

            if self.locationDelegate != nil {
                self.locationDelegate.saveLocation(location: location)
            }
            
            SwiftOverlays.removeAllBlockingOverlays()
            self.dismiss(animated: true, completion: nil)
        })
        
       
    }
    
    // fetcher
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        locations.removeAll()
        
        for prediction in predictions {
            let location = Location()
            location.location = prediction.attributedPrimaryText.string
            location.desc = prediction.attributedSecondaryText?.string
            location.fullAddress = prediction.attributedFullText.string
            location.placeId = prediction.placeID
            locations.append(location)
        }
        
        tableView.reloadData()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        locations.removeAll()
        tableView.reloadData()
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetcher?.sourceTextHasChanged(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        locations.removeAll()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
