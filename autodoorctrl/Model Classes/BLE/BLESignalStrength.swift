//
//  BLESignalStrength.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 2/23/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import UIKit

@objc enum BLESignalStrength: Int {
    case unusable
    case bad
    case ok
    case good
    case amazing
    
    /// Using `~=` instead of the conventional switch operator to demonstrate
    /// pattern matching in Swift
    /// - Metrics obtained from https://www.metageek.com/training/resources/understanding-rssi.html
    init(rssi: Int) {
        if -70 ..< -66 ~= rssi {
            self = .good
        } else if -80 ..< -70 ~= rssi {
            self = .ok
        } else if -90 ..< -80 ~= rssi {
            self = .bad
        } else if rssi < -90 {
            self = .unusable
        } else {
            self = .amazing
        }
    }
    
    /// localized descriptions for the signal strength.
    var strengthDescription: String {
        switch self {
        case .unusable:
            return NSLocalizedString("BLESignalUnusable", comment: "")
        case .bad:
            return NSLocalizedString("BLESignalBad", comment: "")
        case .ok:
            return NSLocalizedString("BLESignalOK", comment: "")
        case .good:
            return NSLocalizedString("BLESignalGood", comment: "")
        case .amazing:
            return NSLocalizedString("BLESignalAmazing", comment: "")
        }
    }
    
    var strengthImage: UIImage? {
        switch self {
        case .unusable:
            return UIImage(named: "BLESignalUnusable")
        case .bad:
            return UIImage(named: "BLESignalBad")
        case .ok:
            return UIImage(named: "BLESignalOK")
        case .good:
            return UIImage(named: "BLESignalGood")
        case .amazing:
            return UIImage(named: "BLESignalAmazing")
        }
    }
    
}
