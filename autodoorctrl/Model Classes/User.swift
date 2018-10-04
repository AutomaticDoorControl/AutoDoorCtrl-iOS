//
//  User.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation


/**
 * A class representing the current user.
 */
class User: NSObject {
    static let current = User.init()
    
    var rcsID: String = ""
    var isActive: Bool = false
    
    override init() { super.init() }
    
    func setUp(codableObject: UserFromCodable) {
        rcsID = codableObject.rcsID
        isActive = codableObject.isActive.hasPrefix("Active")
    }
    
    override var debugDescription: String {
        return "User - rcsID:\(rcsID), active?: \(isActive)"
    }
    
}

class UserFromCodable: Codable {
    
    let rcsID: String
    let isActive: String
    
    private enum CodingKeys: String, CodingKey {
        case rcsID = "RCSid"
        case isActive = "Status"
    }
}
