//
//  DoorResponse.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 4/5/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct DoorResponse: Codable {
    let data: [DoorResponseData]
    
    struct DoorResponseData: Codable {
        let name: String
        let location: String
        let latitude: Double
        let longitude: Double
    }
}
