//
//  FirebaseAuthService.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 11/9/23.
//
import Foundation
import FirebaseAuth

class FirebaseAuthService: AuthService {
    
    private let keychainManager = KeychainManager()
    
    func registerUser(email: String, password: String, completion: @escaping (FirebaseAuthResult) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let authResult = authResult {
                let user = UserData(id: authResult.user.uid, email: authResult.user.email ?? "", favoriteCompanies: [])
                completion(.success(user))
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (FirebaseAuthResult) -> Void) {
        print("Intentando iniciar sesión con email: \(email)")

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error al intentar iniciar sesión: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                let noAuthResultError = NSError(domain: "FirebaseAuthService", code: 9997, userInfo: [NSLocalizedDescriptionKey: "No auth result available."])
                print("Resultado de autenticación no disponible.")
                completion(.failure(noAuthResultError))
                return
            }

            // Guardar el token en el Keychain
            if let token = authResult.user.refreshToken {
                self.keychainManager.saveToken(token)
            }

            print("Inicio de sesión exitoso para el usuario: \(authResult.user.email ?? "Desconocido")")
            let user = UserData(id: authResult.user.uid, email: authResult.user.email ?? "", favoriteCompanies: LocalStorageService.shared.getFavoriteCompanies())
            completion(.success(user))
        }
    }
    /*
    func loginUser(email: String, password: String, completion: @escaping (FirebaseAuthResult) -> Void) {
        print("Intentando iniciar sesión con email: \(email)")

        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error al intentar iniciar sesión: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let authResult = authResult else {
                let noAuthResultError = NSError(domain: "FirebaseAuthService", code: 9997, userInfo: [NSLocalizedDescriptionKey: "No auth result available."])
                print("Resultado de autenticación no disponible.")
                completion(.failure(noAuthResultError))
                return
            }

            print("Inicio de sesión exitoso para el usuario: \(authResult.user.email ?? "Desconocido")")
            let user = UserData(id: authResult.user.uid, email: authResult.user.email ?? "", favoriteCompanies: LocalStorageService.shared.getFavoriteCompanies())
            completion(.success(user))
        }
    }
     */

}


