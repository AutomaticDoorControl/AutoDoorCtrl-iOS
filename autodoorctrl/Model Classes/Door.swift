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
    let location: String
    let coordinate: CLLocationCoordinate2D
    var peripheral: CBPeripheral?
    
    init?(peripheral: CBPeripheral,
          prefetchedDoors: [String: DoorResponse.DoorResponseData]) {
        if let name = peripheral.name?.trimmingCharacters(in: .whitespacesAndNewlines),
            let prefetchedReponse = prefetchedDoors[name] {
            self.peripheral = peripheral
            self.name = name
            location = prefetchedReponse.location
            coordinate = CLLocationCoordinate2D(latitude: prefetchedReponse.latitude,
                                                longitude: prefetchedReponse.longitude)
            super.init()
        } else {
            return nil
        }
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return location
    }
    
    override var debugDescription: String {
        return "Door name: \(name), location: \(location), latitude: \(coordinate.latitude), longitude: \(coordinate.longitude)"
    }
}
