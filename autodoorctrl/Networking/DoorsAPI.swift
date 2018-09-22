//
//  DoorsAPI.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

enum DoorsAPI {
    
    static func fetchDoorsInfo(from currentLocation: CLLocationCoordinate2D?,
                               onSuccess: @escaping ([Door]) -> Void,
                               onError: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let doors = [Door(name: "Church I", longitude: -73.6780, latitude: 42.7306),
                         Door(name: "Hunt III", longitude: -73.6777, latitude: 42.7302),
                         Door(name: "White IV", longitude: -73.6778, latitude: 42.7296)]
            onSuccess(doors)
        }
    }
    
}
