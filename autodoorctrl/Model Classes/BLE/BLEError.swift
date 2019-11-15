//
//  BLEError.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreBluetooth

enum BLEError: Error {
    // case genericError(error: Error?)
    case bluetoothOff
    case connectionTimeout
    case peripheralDisconnected
    case unexpected
    case inactiveConnection
    case unsupportedDevice
    case unauthrozied
    case invalidTOTP
    
    init?(managerState: CBManagerState) {
        switch managerState {
        case .unknown, .resetting:
            self = .unexpected
        case .unsupported:
            self = .unsupportedDevice
        case .unauthorized:
            self = .unauthrozied
        case .poweredOff:
            self = .bluetoothOff
        default:
            return nil
        }
    }
    
    init?(errorMessage: String) {
        if errorMessage == "INVALID TOKEN" {
            self = .invalidTOTP
        } else {
            return nil
        }
    }
    
    var errorDesctription: String {
        switch self {
        case .bluetoothOff:
            return  "Bluetooth is off"
        case .connectionTimeout:
            return "Connection timed out"
        case .peripheralDisconnected:
            return "Bluetooth Device Disconnected"
        case .unexpected:
            return "Unexpected Error Encountered"
        case .inactiveConnection:
            return "No BLE device is currently connected"
        case .unsupportedDevice:
            return "Your device does not support Bluetooth"
        case .unauthrozied:
            return "You did not allow the app to use Bluetooth"
        case .invalidTOTP:
            return "Failed to send the correct totp token"
        }
    }
    
    func showErrorMessage() {
        SwiftMessagesWrapper.showErrorMessage(title: "Error", body: errorDesctription)
    }
}

extension BLEError: LocalizedError {
    var errorDescription: String? {
        return errorDesctription
    }
}
