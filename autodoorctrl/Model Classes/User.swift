//
//  User.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/30/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import SwiftJWT

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
    init(session: Session, isAdmin: Bool) throws {
        if session.sessionID.isEmpty {
            throw NSError(domain: "Invalid username or password, or the user is inactive", code: 0, userInfo: nil)
        }
        
        let keyName = isAdmin ? "adminPublic" : "userPublic"
        let keyString: String
        if let path = Bundle.main.path(forResource: keyName, ofType: "key") {
            keyString = try String(contentsOfFile: path, encoding: .utf8)
        } else {
            throw NSError(domain: "Invalid public key", code: 0, userInfo: nil)
        }
        let newJWT = try JWT<ADCClaim>(
            jwtString: session.sessionID,
            verifier: JWTVerifier.rs256(publicKey: keyString.data(using: .utf8)!))
        let claim = newJWT.claims
        
        rcsID = claim.sub
        isActive = true
        self.isAdmin = isAdmin
        self.session = session
        super.init()
        
        User.current = self
    }
    
    override var debugDescription: String {
        return "User - rcsID:\(rcsID), active?: \(isActive)"
    }
}
