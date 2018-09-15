//
//  TestKeychainOperations.swift
//  autodoorctrlTests
//
//  Created by Jing Wei Li on 9/15/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import XCTest

class TestKeychainOperations: XCTestCase {
    private let rcsID = "abc"
    private let existingPassword = "password1"
    private let newPassword = "newPassword"
    private var isTestingDeletion: Bool!
    
    override func setUp() {
        isTestingDeletion = false
        do {
            try KeychainOperations.deletePassword(matching: rcsID)
        } catch {
            // delete the existing password to prepare for testing. Intentionally left blank.
        }
    }

    func testKeychain() {
        do {
            // saving password
            try KeychainOperations.savePassword(existingPassword, attachedToRCSID: rcsID)
            let retrievedPassword = try KeychainOperations.retrievePassword(matching: rcsID)
            XCTAssertEqual(retrievedPassword, existingPassword, "Saved Passowrd Does Not Match Existing")
            
            // updating password
            try KeychainOperations.updatePassword(matching: rcsID, withNewPassword: newPassword)
            let retrievedNewPassword = try KeychainOperations.retrievePassword(matching: rcsID)
            XCTAssertEqual(retrievedNewPassword, newPassword, "Password Not Updated Correctly")
            
            // deleting password
            isTestingDeletion = true
            try KeychainOperations.deletePassword(matching: rcsID)
            // should throw the no password error
            let _ = try KeychainOperations.retrievePassword(matching: rcsID)

        } catch {
            switch error as! KeychainOperations.KeychainError {
            case .passwordNotFound:
                // if successfully deleting the password, retrieving it will throw this error.
                if !isTestingDeletion {
                    XCTFail("Error Updating Password: Password Not Found")
                }
            case .unhandledError(let status):
                XCTFail("Error Updating Password with Error: \(status)")
            case .unexpectedError:
                XCTFail("Error Updating Password: Unexpected Error")
            }

        }
    }

}
