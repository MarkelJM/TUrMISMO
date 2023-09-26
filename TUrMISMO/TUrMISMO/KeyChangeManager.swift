//
//  KeyChangeManager.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 23/9/23.
//

import Foundation
import KeychainSwift

class KeychainManager {
    
    private let keychain = KeychainSwift()
    private let tokenKey = "firebaseToken"
    
    // Guarda el token en el Keychain
    func saveToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
    }
    
    // Recupera el token del Keychain
    func getToken() -> String? {
        return keychain.get(tokenKey)
    }
    
    // Elimina el token del Keychain
    func logout() {
        keychain.delete(tokenKey)
    }
}
