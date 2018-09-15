//
//  KeychainOperations.swift
//  autodoorctrl
//
//  Created by Jing Wei Li on 9/14/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import Foundation
import Security

/**
 A caseless enum whose functionality is to manipulate the user's password securely by
 using Apple's Keychain API.
 */
enum KeychainOperations {
    private static let service = "KeychainService"
    
    enum KeychainError: Error {
        case passwordNotFound
        case unhandledError(status: OSStatus)
        case unexpectedError
    }
    
    static func savePassword(_ password: String, attachedToRCSID rcsID: String) throws {
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: rcsID,
                                    kSecAttrService as String: service,
                                    kSecValueData as String: encodedPassword]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    static func retrievePassword(matching rcsID: String) throws -> String {
        let searchQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: rcsID,
                                          kSecAttrService as String: service,
                                          kSecMatchLimit as String: kSecMatchLimitOne,
                                          kSecReturnAttributes as String: true,
                                          kSecReturnData as String: true]
        
        var searchResult: CFTypeRef?
        let searchStatus = SecItemCopyMatching(searchQuery as CFDictionary, &searchResult)
        guard searchStatus != errSecItemNotFound else { throw KeychainError.passwordNotFound }
        guard searchStatus == errSecSuccess else { throw KeychainError.unhandledError(status: searchStatus) }
        guard let resultDict = searchResult as? [String: Any],
            let passwordData = resultDict[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8) else {
                throw KeychainError.unexpectedError
        }
    
        return password
    }
    
    static func deletePassword(matching rcsID: String) throws {
        let deleteQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrAccount as String: rcsID,
                                          kSecAttrService as String: service]
        let deleteStatus = SecItemDelete(deleteQuery as CFDictionary)
        guard deleteStatus == errSecSuccess || deleteStatus == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: deleteStatus)
        }
    }
    
    static func updatePassword(matching rcsID: String, withNewPassword password: String) throws {
        let updateQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                          kSecAttrService as String: service]
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        let passwordToUpdate: [String: Any] = [kSecAttrAccount as String: rcsID,
                                               kSecValueData as String: encodedPassword]
        
        let updateStatus = SecItemUpdate(updateQuery as CFDictionary, passwordToUpdate as CFDictionary)
        guard updateStatus != errSecItemNotFound else { throw KeychainError.passwordNotFound }
        guard updateStatus == errSecSuccess else { throw KeychainError.unhandledError(status: updateStatus) }
    }
    
}
