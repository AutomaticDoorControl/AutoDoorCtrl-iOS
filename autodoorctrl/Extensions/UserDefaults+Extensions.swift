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
    //TODO: Store the information below in Keychain
    private static let rcsIDKey = "rcsIDKey"
    private static let passwordKey = "passwordKey"
    
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
    
    // MARK: - RCSID and Password
    static func saveLoginCredentials(rcsID: String, password: String) {
        self.standard.set(rcsID, forKey: rcsIDKey)
        self.standard.set(password, forKey: passwordKey)
    }
    
    static func rcsID() -> String {
        return self.standard.object(forKey: rcsIDKey) as? String ?? ""
    }
    
    static func password() -> String {
        return self.standard.object(forKey: passwordKey) as? String ?? ""
    }
    
}
