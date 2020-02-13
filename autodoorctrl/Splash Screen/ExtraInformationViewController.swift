//
//  ExtraInformationViewController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/12/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ExtraInformationViewController: PageContentViewController {
    let dataSets = ExtraInfoDataSets()
    var didDismiss: (() -> Void) = {}
    let locationManager = CLLocationManager()
    
    // MARK: - Init
    init() {
        super.init(dataSet: dataSets.extraInfoDataSet)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override var buttonText: String? {
        return "Give Permissions"
    }
    
    override func buttonTapped(sender: UIButton) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    override var buttonBackgroundColor: UIColor {
        return Constants.adcRed
    }
    
    override var buttonTextColor: UIColor {
        return .white
    }
}

extension ExtraInformationViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        BLEManager.current.delegate = self // trigger the app to ask BLE permission
    }
}

extension ExtraInformationViewController: BLEManagerDelegate {
    func didAuthorize() {
        dismiss(animated: true) { [weak self] in
            self?.didDismiss()
        }
    }
}
