//
//  User.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

/// A class representing the current user.
class User: NSObject {
    static var current = User()
    
    var rcsID: String = ""
    var isActive: Bool = false
    var isAdmin: Bool = false
    let session: Session
    
    /// do not use this initializer.
    override init() {
        rcsID = ""
        isActive = false
        isAdmin = false
        session = Session(sessionID: "")
        super.init()
    }
    
    init(userResponse: ServicesAPI.UserResponse) {
        self.rcsID = userResponse.rcsID
        self.isActive = userResponse.status.hasPrefix("Active")
        isAdmin = false
        session = Session(sessionID: "")
        super.init()
    }
    
    /// Designated initializer to initialize a user from the provided session containing a jwt token received from login.
    @discardableResult
    init(session: Session, rcsID: String) throws {
        if session.sessionID.isEmpty {
            throw "Invalid username or password, or the user is inactive"
        }
        
        self.rcsID = rcsID
        isActive = true
        self.isAdmin = session.admin == 1
        self.session = session
        super.init()
        
        User.current = self
    }
    
    override var debugDescription: String {
        return "User - rcsID:\(rcsID), active?: \(isActive), admin: \(isAdmin), session: \(session.sessionID)"
    }
}
