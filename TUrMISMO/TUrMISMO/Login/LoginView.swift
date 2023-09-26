//
//  LoginView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 9/9/23.
//
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: LoginViewModel

    @State private var email = ""
    @State private var password = ""

    init(appState: AppState) {
        self.viewModel = LoginViewModel(appState: appState)
    }

    var body: some View {
        ZStack {
            // Fondo
            Image("fondoApp")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.bottom, 100)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 39/255, green: 73/255, blue: 106/255), lineWidth: 2)
                    )
                    .padding(.bottom, 10)

                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 39/255, green: 73/255, blue: 106/255), lineWidth: 2)
                    )
                    .padding(.bottom, 10)

                Button("Iniciar") {
                    viewModel.login(email: email, password: password)
                }
                .padding()
                .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom, 10)

                Button("Registrarse") {
                    appState.currentView = .register
                }
                .padding(.bottom, 10)
                .foregroundColor(Color.white)

                Button("¿Olvidó la contraseña?") {
                    viewModel.forgotPassword(email: email)
                }
                .foregroundColor(Color.white)


                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding(.top, 20)
                }
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(appState: AppState())
    }
}
