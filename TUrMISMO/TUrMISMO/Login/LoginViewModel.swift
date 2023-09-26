//
//  LoginViewModel.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 9/9/23.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var error: String?
    @Published var appState: AppState? = nil

    private var authService: AuthService = FirebaseAuthService()
    
    init(appState: AppState) {
        self.appState = appState
    }
        
    func login(email: String, password: String) {
        print("ViewModel intentando iniciar sesión...")

        // Si el email y la contraseña son los de prueba, permitimos el acceso directo.
        if email == "Prueba" && password == "123456789"{
            print("Email de prueba detectado.")
            self.isAuthenticated = true
            self.appState?.currentView = .touristList
            return
        }

        // Utilizamos el servicio de autenticación aquí
        authService.loginUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                print("ViewModel - Autenticación exitosa para usuario: \(user.email)")
                self?.isAuthenticated = true
                self?.appState?.currentView = .touristList
            case .failure(let error):
                print("ViewModel - Error al autenticar: \(error.localizedDescription)")
                self?.error = error.localizedDescription
            }
        }
    }






    func forgotPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.error = error.localizedDescription
            } else {
                // Notificar al usuario para que revise su correo
                self.error = "Please check your email for password reset instructions."
            }
        }
    }
}
