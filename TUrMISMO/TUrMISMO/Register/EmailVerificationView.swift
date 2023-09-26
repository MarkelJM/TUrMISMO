//
//  EmailVerificationView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 9/9/23.
//
import SwiftUI
import FirebaseAuth

struct EmailVerificationView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            // Fondo
            Image("fondoApp")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("Verificación de Email")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 90)

                VStack(spacing: 20) {
                    Text("Por favor, verifica tu email")
                        .font(.headline)
                        .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255)) // Color principal

                    Text("Hemos enviado un enlace de verificación a tu dirección de correo electrónico. Por favor, verifica para continuar.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255)) // Color principal
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 39/255, green: 73/255, blue: 106/255), lineWidth: 2)
                )
                .padding(.bottom, 90)

                Button(action: {
                    Auth.auth().currentUser?.reload(completion: { (error) in
                        if Auth.auth().currentUser?.isEmailVerified == true {
                            appState.currentView = .login
                        }
                    })
                }) {
                    Text("Ya he verificado")
                }
                .padding()
                .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                .foregroundColor(.white)
                .cornerRadius(8)

                Button(action: {
                    appState.currentView = .login
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.white)
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct EmailVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationView()
    }
}
