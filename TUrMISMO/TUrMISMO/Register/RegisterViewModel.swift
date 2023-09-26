//
//  RegisterViewModel.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 9/9/23.
//

import Foundation
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    @Published var error: String?
    @Published var isRegistered = false

    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.error = error.localizedDescription
            } else {
                authResult?.user.sendEmailVerification(completion: { error in
                    if let error = error {
                        self.error = error.localizedDescription
                    } else {
                        self.isRegistered = true
                    }
                })
            }
        }
    }
}
