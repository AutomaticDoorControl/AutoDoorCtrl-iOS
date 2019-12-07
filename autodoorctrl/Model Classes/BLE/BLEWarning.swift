//
//  BLEWarning.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 11/13/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

@objc enum BLEWarning: Int {
    case scanningTimeout
    
    var warningDescription: String {
        switch self {
        case .scanningTimeout:
            return "No Doors Found Near You"
        }
    }
    
    func showWarningMessage() {
        SwiftMessagesWrapper.showWarningMessage(title: "Oops", body: warningDescription)
    }
}
