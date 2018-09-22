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


class Door: NSObject, MKAnnotation {
    static let identifier = "DoorIdentifier"
    
    let name: String
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, longitude: Double, latitude: Double) {
        self.name = name
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return "Coordinate: \(self.coordinate.latitude), \(self.coordinate.longitude)"
    }
}
