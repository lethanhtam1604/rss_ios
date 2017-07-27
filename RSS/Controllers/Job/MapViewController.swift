//
//  MapViewController.swift
//  RSS
//
//  Created by Thanh-Tam Le on 3/27/17.
//  Copyright © 2017 Lavamy. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    var anotation = MKPointAnnotation()
    
    var latitude: Double?
    var longitude: Double?

    var constraintsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Global.colorBg
        view.tintColor = Global.colorSignin
        view.addTapToDismiss()
        
        //enable swipe back when it changed leftBarButtonItem
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        title = "Map"
        
        let backBarButton = UIBarButtonItem(image: UIImage(named: "i_nav_back"), style: .done, target: self, action: #selector(cancel))
        backBarButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = backBarButton
        
        view.addSubview(mapView)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        if !constraintsAdded {
            constraintsAdded = true
            
            mapView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeLocation)))
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.addAnnotation(anotation)
        mapView.backgroundColor = Global.colorBg
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    var customLocation = false
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !customLocation {
            var mapRegion = MKCoordinateRegion()
            let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
//            let coordinate = mapView.userLocation.coordinate
            anotation.coordinate = coordinate
            mapRegion.center = coordinate
            mapRegion.span.latitudeDelta = 0.002
            mapRegion.span.longitudeDelta = 0.002
            mapView.setRegion(mapRegion, animated: true)
            customLocation = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways && status != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }
    }
    
    func changeLocation(gestureRecognizer: UIGestureRecognizer) {
        customLocation = true
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        anotation.coordinate = touchMapCoordinate
    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
}
