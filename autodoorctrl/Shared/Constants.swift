//
//  Constants.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/27/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static let kMapListRightConstraintLength: CGFloat = 17
    static let apiStart = "http://a8ee78d5.ngrok.io/"
    //static let apiStart = "http://localhost:8080/"
    
    static let toggleCommand = "a"
    
    enum IncomingCommands {
        static let offCommand = "OFF"
        static let onCommand = "ON"
    }
}
