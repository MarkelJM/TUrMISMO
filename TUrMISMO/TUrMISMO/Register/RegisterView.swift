//
//  RegisterView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 9/9/23.
//
import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()
    @EnvironmentObject var appState: AppState

    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPasswordAlert = false

    var body: some View {
        ZStack {
            // Fondo
            Image("fondoApp")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Registrar")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 100)
                

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 39/255, green: 73/255, blue: 106/255), lineWidth: 2)
                    )

                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 39/255, green: 73/255, blue: 106/255), lineWidth: 2)
                    )

                SecureField("Confirmar Contraseña", text: $confirmPassword)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 39/255, green: 73/255, blue: 106/255), lineWidth: 2)
                    )

                Button("Registrar") {
                    if password == confirmPassword {
                        viewModel.register(email: email, password: password)
                    } else {
                        showPasswordAlert = true
                    }
                }
                .padding()
                .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                .foregroundColor(.white)
                .cornerRadius(8)
                .alert(isPresented: $showPasswordAlert) {
                    Alert(title: Text("Error"), message: Text("Las contraseñas no coinciden."), dismissButton: .default(Text("OK")))
                }

                if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button(action: {
                    appState.currentView = .login
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.white)
                        .padding()
                        
                }
            }
            .padding()
            .onChange(of: viewModel.isRegistered) { isRegistered in
                if isRegistered {
                    appState.currentView = .emailVerification
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
