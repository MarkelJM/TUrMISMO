//
//  OnboardingView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppState
    @State private var progressValue: Double = 0.0
    @State private var showAlert = false
    let animationDuration: Double = 2.0  // Duración de la animación aumentada para dar tiempo a la comprobación
    
    let keychainManager = KeychainManager()
    
    var body: some View {
        GeometryReader { geometry in
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
                        .frame(width: geometry.size.width * 0.4)
                        .padding(.top, 50)

                    Spacer()

                    // Barra de progreso
                    ProgressView(value: progressValue, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: Color.white))
                        .frame(height: 20)
                        .padding(.horizontal, 50)
                        .onAppear {
                            if Reachability.isConnectedToNetwork() {
                                withAnimation(.linear(duration: animationDuration)) {
                                    progressValue = 1.0
                                }
                                DispatchQueue.global().async {
                                    sleep(UInt32(animationDuration))
                                    DispatchQueue.main.async {
                                        if keychainManager.getToken() != nil {
                                            // Si hay un token, se pasa a la vista principal.
                                            appState.currentView = .touristList
                                        } else {
                                            // Si no hay un token, se pasa a la vista de inicio de sesión.
                                            appState.currentView = .login
                                        }
                                    }
                                }
                            } else {
                                showAlert = true
                            }
                        }

                    Spacer()
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sin conexión a Internet"), message: Text("Por favor, conecta tu dispositivo a Internet y vuelve a intentarlo."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(appState: AppState())
    }
}

