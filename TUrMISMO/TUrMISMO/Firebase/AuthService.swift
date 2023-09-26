//
//  AuthService.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 11/9/23.
//

import Foundation
import FirebaseAuth

enum FirebaseAuthResult {
    case success(UserData)
    case failure(Error)
}

protocol AuthService {
    func registerUser(email: String, password: String, completion: @escaping (FirebaseAuthResult) -> Void)
    func loginUser(email: String, password: String, completion: @escaping (FirebaseAuthResult) -> Void)
}
