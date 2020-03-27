//
//  Session.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 10/19/19.
//  Copyright © 2019 Jing Wei Li. All rights reserved.
//

import Foundation

struct Session: Codable {
    let sessionID: String
    let admin: Int
    
    private enum CodingKeys: String, CodingKey {
        case sessionID = "SESSIONID"
        case admin = "admin"
    }
    
    init(sessionID: String) {
        self.sessionID = sessionID
        self.admin = 0
    }
    
}
