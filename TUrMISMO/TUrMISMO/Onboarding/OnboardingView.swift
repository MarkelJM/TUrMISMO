//
//  OnboardingView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var isLoading = false
    @State private var showAlert = false
    
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

                    // Botón
                    Button(action: {
                        if Reachability.isConnectedToNetwork() {
                            isLoading = true
                            // Simula una carga de datos de 1 segundo
                            DispatchQueue.global().async {
                                sleep(1)
                                DispatchQueue.main.async {
                                    isLoading = false
                                    isOnboardingCompleted = true
                                }
                            }
                        } else {
                            showAlert = true
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 39/255, green: 73/255, blue: 106/255)))
                                .padding(30)
                                .background(Circle().fill(Color.white))
                        } else {
                            Text("Iniciar")
                                .font(.largeTitle)
                                .padding(30)
                                .background(Circle().fill(Color.white))
                                .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255))
                        }
                    }
                    .padding(.bottom, 89)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Sin conexión a Internet"), message: Text("Por favor, conecta tu dispositivo a Internet y vuelve a intentarlo."), dismissButton: .default(Text("OK")))
                    }

                    Spacer()
                }
            }
        }

    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboardingCompleted: .constant(false))
    }
}


