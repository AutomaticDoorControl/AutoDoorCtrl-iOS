//
//  BLEManagerDelegate.swift
//  smartdesk
//
//  Created by Jing Wei Li on 10/10/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import CoreBluetooth

@objc protocol BLEManagerDelegate: class {
    @objc optional func didDisconnectFromPeripheral()
    @objc optional func readyToSendData()
    @objc optional func didReceiveError(error: Error?)
    @objc optional func didReceiveRSSIReading(reading: BLESignalStrength)
    @objc optional func didReceiveMessage(message: String)
    @objc optional func didDiscoverDoors(doors: [Door])
    @objc optional func didReceiveWarning(warning: BLEWarning)
}
