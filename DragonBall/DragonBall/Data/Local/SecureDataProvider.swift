//
//  KeychainProvider.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 2/15/24.
//

import Foundation
import KeychainSwift

// MARK: - SecureDataProviderProtocol
// This protocol defines operations for saving and retrieving secure data, such as authentication tokens, using secure storage.
public protocol SecureDataProviderProtocol {
    // Saves a security token in secure storage.
    func save(token: String)
    
    // Retrieves the security token from secure storage.
    // Returns nil if the token does not exist.
    func getToken() -> String?
}

// MARK: - SecureDataProvider
// Concrete implementation of SecureDataProviderProtocol using KeychainSwift for secure storage.
final class SecureDataProvider: SecureDataProviderProtocol {
    // Instance of KeychainSwift to interact with the system's Keychain.
    private let keychain = KeychainSwift()
    
    // Keys used to store and retrieve data from Keychain.
    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    // Saves a token in Keychain.
    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }
    
    // Retrieves a token from Keychain.
    // Returns nil if the token cannot be found.
    func getToken() -> String? {
        return keychain.get(Key.token)
    }
}
