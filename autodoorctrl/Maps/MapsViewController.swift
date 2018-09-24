//
//  MapsViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/21/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, MapToDoorCommDelegate {
    @IBOutlet weak var backButtonBackground: UIVisualEffectView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doorsListView: UIView!
    @IBOutlet weak var doorsListHeight: NSLayoutConstraint!
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var isDoorsListExpanded = false
    private var keepingRegionScale = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonBackground.addRoundedCorner()
        doorsListView.addRoundedCorner()
        doorsListView.addBorders(width: 0.3)
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        (children.first as? DoorsListTableViewController)?.delegate = self
        
        determineCurrentLocation()
    }
    
    // MARK: - MapKit Methods
    
    func centerMapOnUserLocation(from coordinate: CLLocationCoordinate2D) {
        let region = keepingRegionScale
            ? MKCoordinateRegion(center: coordinate, span: mapView.region.span)
            : MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func determineCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        centerMapOnUserLocation(from: userLocation.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - MapToDoorCommDelegate
    
    func didReceiveDoorsData(with doors: [Door]) {
        mapView.addAnnotations(doors)
    }
    
    func didSelectSingleDoor(with door: Door) {
        keepingRegionScale = true
        if isDoorsListExpanded { collapseList() }
        centerMapOnUserLocation(from: door.coordinate)
        mapView.selectAnnotation(door, animated: true)
    }
    
    func collapseList() {
        guard doorsListHeight.constant != 170 else { return }
        doorsListView.layoutIfNeeded()
        isDoorsListExpanded = !isDoorsListExpanded
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.doorsListHeight.constant = 170
            self?.doorsListView.layoutIfNeeded()
        }
    }
    
    func expandList() {
        guard doorsListHeight.constant == 170 else { return }
        doorsListView.layoutIfNeeded()
        isDoorsListExpanded = !isDoorsListExpanded
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.doorsListHeight.constant = UIScreen.main.bounds.height * 0.6
            self?.doorsListView.layoutIfNeeded()
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let doorAnnotation = annotation as? Door else { return nil }
        var view: MKAnnotationView
        if #available(iOS 11.0, *) {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: Door.identifier)
            as? MKMarkerAnnotationView {
                dequeuedView.annotation = doorAnnotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: doorAnnotation, reuseIdentifier: Door.identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let doorButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                doorButton.setImage(UIImage(named: "UnlockIcon"), for: .normal)
                view.rightCalloutAccessoryView = doorButton
            }
            return view
        }
        return MKAnnotationView(annotation: annotation, reuseIdentifier: Door.identifier)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "showSwitchVC", sender: self)
    }
    
    
    // MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARKL - Private
    
}
