//
//  DoorsListController.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import CoreLocation

class DoorsListController: NSObject {
    var doors: [Door] = []
    
    override init() {
        super.init()
    }
    
    func fetchDoorsInfo(from location: CLLocationCoordinate2D?,
                        successHandler: @escaping () -> Void,
                        errorHandler: @escaping (Error?) -> Void) {
        DoorsAPI.fetchDoorsInfo(from: location,
                                onSuccess: { doors in
                                    self.doors = doors
                                    DispatchQueue.main.async {
                                        successHandler()
                                    }
        },
                                onError: { error in
                                        errorHandler(error)
        })
    }
    
    

}
