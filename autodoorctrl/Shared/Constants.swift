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
    static let apiStart = "https://rpiadc.com/"
    //static let apiStart = "http://localhost:8080/"
    
    static let doorClosingTime = 20
    
    static let adcRed = UIColor(red: 238/255, green: 50/255, blue: 35/255, alpha: 1)
    
    static let supportEmails = ["fixx@rpi.edu", "webmaster@rpiadc.com"]
    
    enum IncomingCommands {
        static let offCommand = "CLOSED"
        static let onCommand = "OPEN"
    }
}
