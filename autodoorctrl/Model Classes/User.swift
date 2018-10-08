//
//  User.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation


/**
 * A class representing the current user. It conforms to Codable so it's easier
 * to parse data from JSON.
 */
class User: NSObject, Codable {
    static var current = User()
    
    var rcsID: String = ""
    var isActive: Bool = false
    
    override init() {
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case rcsID = "RCSid"
        case isActive = "Status"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rcsID = (try container.decode(String.self, forKey: .rcsID)).trimmingCharacters(in: .whitespaces)
        isActive = (try container.decode(String.self, forKey: .isActive)).hasPrefix("Active")
    }
    
    override var debugDescription: String {
        return "User - rcsID:\(rcsID), active?: \(isActive)"
    }
}
