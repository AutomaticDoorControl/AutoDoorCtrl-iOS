//
//  User.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

/**
 * A singleton representing the current user.
 */
class User {
    static let current = User.init()
    
    var rcsID: String = ""
    var isActive: Bool = false
    
    init() {}
}
