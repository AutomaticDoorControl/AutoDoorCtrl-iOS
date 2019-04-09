//
//  DoorsListViewModel.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/22/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import CoreLocation

class DoorListViewModel: NSObject {
    var doors: [Door] = []
    
    override init() {
        super.init()
    }

    func fetchDoorsInfo(
        from location: CLLocationCoordinate2D? = nil,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (Error) -> Void)
    {
        DoorsAPI.prefetchDoorsData(success: {
            DispatchQueue.main.async {
                successHandler()
            }
        }, error: { err in
            DispatchQueue.main.async {
                errorHandler(err)
            }
        })
    }
}
