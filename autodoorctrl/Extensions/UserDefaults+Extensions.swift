//
//  UserDefaults+Extensions.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/14/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation

extension UserDefaults {
    private static let firstLoginKey = "firstLogin"
    private static let biometricLoginAgreementKey = "agreedToBiometrics"
    private static let rcsIDKey = "rcsIDKey"
    
    // MARK: - First Login
    
    static func isFirstLogin() -> Bool {
        return !self.standard.bool(forKey: firstLoginKey)
    }
    
    static func setFirstLogin() {
        self.standard.set(true, forKey: firstLoginKey)
    }
    
    // MARK: - Biometrics
    
    static func isUserAgreedToBiometrics() -> Bool {
        return self.standard.bool(forKey: biometricLoginAgreementKey)
    }
    
    static func setBiometricAgreement() {
        self.standard.set(true, forKey: biometricLoginAgreementKey)
    }
    
    static func resetBiometricAgreement() {
        self.standard.set(false, forKey: biometricLoginAgreementKey)
    }
    
    // MARK: - RCSID (Passwords are saved to the keychain)
    static func saveRCSID(with rcsID: String) {
        self.standard.set(rcsID, forKey: rcsIDKey)
    }
    
    static func rcsID() -> String {
        return self.standard.object(forKey: rcsIDKey) as? String ?? ""
    }
    
}
