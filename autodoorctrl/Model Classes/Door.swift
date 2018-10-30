//
//  Door.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import CoreBluetooth


class Door: NSObject, MKAnnotation {
    static let identifier = "DoorIdentifier"
    
    let name: String
    let coordinate: CLLocationCoordinate2D
    var peripheral: CBPeripheral?
    
    init(peripheral: CBPeripheral) {
        name = peripheral.name ?? "No Name"
        self.coordinate = CLLocationCoordinate2D(latitude: 42.7306, longitude: -73.6780)
        self.peripheral = peripheral
    }
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return String(format: NSLocalizedString("DoorSubtitle", comment: ""),
                      coordinate.latitude, coordinate.longitude)
    }
}
