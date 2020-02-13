//
//  DoorResponse.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 4/5/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

class DoorResponse: Codable {
    let name: String
    let location: String
    let latitude: Double
    let longitude: Double
    let mac: String
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(String.self, forKey: .location)
        mac = try container.decode(String.self, forKey: .mac)
        
        guard let latitude = Double(try container.decode(String.self, forKey: .latitude)) else {
            throw "Invalid latitude"
        }
        self.latitude = latitude
        
        guard let longitude = Double(try container.decode(String.self, forKey: .longitude)) else {
            throw "Invalid longitude"
        }
        self.longitude = longitude
    }
}
