//
//  BLEError.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BLEError {
    case genericError(error: Error?)
    case bluetoothOff
    case connectionTimeout
    case scanningTimeout
    case peripheralDisconnected
    case unexpected
    case inactiveConnection
    
    init?(managerState: CBManagerState) {
        switch managerState {
        case .unknown:
            self = .genericError(error: NSError(domain: "Unknown error", code: 0, userInfo: [:]))
        case .resetting:
            self = .genericError(error: NSError(domain: "Resetting", code: 0, userInfo: [:]))
        case .unsupported:
            self = .genericError(error: NSError(domain: "Unsupported", code: 0, userInfo: [:]))
        case .unauthorized:
            self = .genericError(error: NSError(domain: "Unauthorized", code: 0, userInfo: [:]))
        case .poweredOff:
            self = .bluetoothOff
        default:
            return nil
        }
    }
    
    var errorDesctription: String {
        switch self {
        case .genericError(let error):
            return error?.localizedDescription ?? ""
        case .bluetoothOff:
            return  "Bluetooth is off"
        case .connectionTimeout:
            return "Connection timed out"
        case .peripheralDisconnected:
            return "Bluetooth Device Disconnected"
        case .unexpected:
            return "Unexpected Error Encountered"
        case .scanningTimeout:
            return "No Doors Found Near You"
        case .inactiveConnection:
            return "No BLE device is currently connected"
        }
    }
    
    func showErrorMessage() {
        SwiftMessagesWrapper.showErrorMessage(title: "Error", body: errorDesctription)
    }
}
