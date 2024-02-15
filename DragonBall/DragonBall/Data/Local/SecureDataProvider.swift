//
//  KeychainProvider.swift
//  DragonBall
//
//  Created by Juan Carlos Torrejon Cañedo on 15/2/24.
//

import Foundation
import KeychainSwift

protocol SecureDataProviderProtocol {
    func save(token: String)
    func getToken() -> String?
}

final class SecureDataProvider: SecureDataProviderProtocol {
    private let keychain = KeychainSwift()

    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }

    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }

    func getToken() -> String? {
        keychain.get(Key.token)
    }
}
