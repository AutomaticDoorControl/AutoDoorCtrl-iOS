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
    
    private enum CodingKeys: String, CodingKey {
        case sessionID = "SESSIONID"
    }
    
    init(sessionID: String) {
        self.sessionID = sessionID
    }
    
}
