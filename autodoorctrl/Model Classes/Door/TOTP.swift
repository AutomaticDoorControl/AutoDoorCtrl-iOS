//
//  TOTP.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/2/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

/// A totp token received from `DoorAPI`'s  `openDoor()` method.
/// - Example JSON format: `{"TOTP": "659372"}`
struct TOTP: Codable {
    let totp: String
    
    private enum CodingKeys: String, CodingKey {
        case totp = "TOTP"
    }
}
