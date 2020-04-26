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
import RxSwift

class MapsViewController: UIViewController {
    @IBOutlet weak var backButtonBackground: UIVisualEffectView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var doorsListView: UIView!
    @IBOutlet weak var doorsListHeight: NSLayoutConstraint!
    @IBOutlet weak var doorsListWidth: NSLayoutConstraint!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var centerLocationButton: UIButton!
    @IBOutlet weak var refreshBLEButton: UIButton!
    
    private var locationManager: CLLocationManager = CLLocationManager()
    private var isDoorsListExpanded = false
    private var keepingRegionScale = false
    private var centerUser = false
    private var currentAnnotation: Door?
    private var userLocation: MKPointAnnotation?
    var doorsListVC: DoorsListTableViewController?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonBackground.addRoundedCorner()
        doorsListView.addRoundedCorner()
        doorsListView.addBorders(width: 0.3)
        
        settingsButton.accessibilityLabel = NSLocalizedString("SettingsIconTitle", comment: "")
        centerLocationButton.accessibilityHint = NSLocalizedString("CenterUserButtonTitle", comment: "")
        refreshBLEButton.accessibilityLabel = NSLocalizedString("rescanTitle", comment: "")
        
        mapView.showsUserLocation = false
        mapView.delegate = self
        locationManager.delegate = self
        
        doorsListVC = children.first as? DoorsListTableViewController
        doorsListVC?.delegate = self
        
        becomeFirstResponder()
        
        determineCurrentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustDoorListWidth()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        adjustDoorListWidth(using: size.width)
        if doorsListView.frame.height >= size.height * 0.6 {
            collapseList()
        }
    }
    
    // MARK: - MapKit Methods
    
    func centerMapOnUserLocation(from coordinate: CLLocationCoordinate2D) {
        let region = keepingRegionScale
            ? MKCoordinateRegion(center: coordinate, span: mapView.region.span)
            : MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    func determineCurrentLocation() {
        centerUser = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func centerUser(_ sender: UIButton) {
        determineCurrentLocation()
    }
    
    @IBAction func searchFoorDoors(_ sender: UIButton) {
        doorsListVC?.refreshBLEs()
    }
    
    // MARK - Private
    
    private func adjustDoorListWidth(using width: CGFloat = UIScreen.main.bounds.width) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            doorsListWidth.constant = width - Constants.kMapListRightConstraintLength * 2
        }
    }
    
    /**
     Expand or collapse the door list with the given `amount`.
        - move down the list with positive `amount`
        - move up the list with negative `amount`
     - parameter amount: amount of points to animate the list.
     */
    private func animateDoorListCollapsing(amount: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.doorsListView.frame =
                CGRect(x: strongSelf.doorsListView.frame.origin.x,
                       y: strongSelf.doorsListView.frame.origin.y + amount,
                       width: strongSelf.doorsListView.frame.width,
                       height: strongSelf.doorsListView.frame.height - amount)
            strongSelf.doorsListHeight.constant -= amount
            strongSelf.doorsListView.layoutIfNeeded()
        })
    }
    
    // MARK: - Shake gesture for accessibility
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if let door = currentAnnotation, motion == .motionShake {
            let vc = OpeningDoorsViewController(door: door)
            vc.modalPresentationStyle = .overFullScreen
            vc.willDismiss = { [weak self] in self?.view.brighten(duration: 0.3) }
            present(vc, animated: true, completion: nil)
            self.view.dim(duration: 0.3)
        }
    }
}

extension MapsViewController: CLLocationManagerDelegate {
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        if centerUser {
            centerMapOnUserLocation(from: userLocation.coordinate)
            centerUser = false
        }
        if self.userLocation == nil {
            let location = MKPointAnnotation()
            location.title = "My Location"
            location.coordinate = userLocation.coordinate
            mapView.addAnnotation(location)
            self.userLocation = location
        } else {
            self.userLocation?.coordinate = userLocation.coordinate
        }
    }
}

extension MapsViewController: MKMapViewDelegate {
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let doorAnnotation = annotation as? Door {
            // door annotation
            currentAnnotation = doorAnnotation
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: Door.identifier)
            as? MKMarkerAnnotationView {
                dequeuedView.annotation = doorAnnotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: doorAnnotation, reuseIdentifier: Door.identifier)
                view.canShowCallout = true
                view.accessibilityValue = NSLocalizedString("shakeHint", comment: "")
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let doorButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                doorButton.setImage(UIImage(named: "UnlockIcon"), for: .normal)
                view.rightCalloutAccessoryView = doorButton
            }
            return view
        } else {
            // user location annotation
            let identifier = "userLocation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                (annotationView as? MKMarkerAnnotationView)?.markerTintColor = .blue
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.displayPriority = .defaultLow
            return annotationView
        }
    }
    
    /// When user taps the lock button to connect to a door
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let door = view.annotation as? Door {
            let vc = OpeningDoorsViewController(door: door)
            vc.modalPresentationStyle = .overFullScreen
            vc.willDismiss = { [weak self] in self?.view.brighten(duration: 0.3) }
            present(vc, animated: true, completion: nil)
            self.view.dim(duration: 0.3)
        }
    }
}

extension MapsViewController: BLEManagerDelegate {
    func readyToSendData() {
        performSegue(withIdentifier: "showSwitchVC", sender: self)
    }
    
    func didReceiveError(error: Error?) {
        error?.showErrorMessage()
        mapView.removeAnnotations(mapView.annotations)
    }
}

extension MapsViewController: MapToDoorCommDelegate {
    // MARK: - MapToDoorCommDelegate
    
    func didReceiveDoorsData(with doors: [Door]) {
        mapView.addAnnotations(doors)
    }
    
    func didSelectSingleDoor(with door: Door) {
        keepingRegionScale = true
        if UIDevice.current.userInterfaceIdiom == .phone { collapseList() }
        centerMapOnUserLocation(from: door.coordinate)
        mapView.selectAnnotation(door, animated: true)
    }
    
    func collapseList() {
        animateDoorListCollapsing(amount: doorsListView.frame.height - 170) // positive amount
    }
    
    func expandList() {
        isDoorsListExpanded = !isDoorsListExpanded
        // negative amount
        animateDoorListCollapsing(amount: doorsListView.frame.height - UIScreen.main.bounds.height * 0.6)
    }
    
    func animateBottomSheet(amount: CGFloat, scrollToEdge: Bool) {
        isDoorsListExpanded = true
        if scrollToEdge {
            animateDoorListCollapsing(amount: amount)
            return
        }
        doorsListHeight.constant -= amount
        doorsListView.layoutIfNeeded()
    }
}
