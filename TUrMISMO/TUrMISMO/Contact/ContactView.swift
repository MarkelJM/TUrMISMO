//
//  ContactView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 11/9/23.
//
import SwiftUI
import MessageUI
import FirebaseAuth
import Firebase
import FirebaseFunctions

struct ContactView: View {
    var tourist: TouristModel
    @State private var isMailViewShowing = false
    @State private var showEmailOptions = false
    @State private var emailMessage: String = ""
    
    //para emails
    private let mailComposeDelegate = MailDelegate()

    init(tourist: TouristModel) {
        self.tourist = tourist
    }

    var body: some View {
        ZStack {
            // Fondo
            Image("fondoApp")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)  // Ajusta el tamaño según tu logo
                    .padding(.bottom, 50)
                
                // Texto descriptivo
                Text("Aquí podrás contactar con la empresa para reservar u obtener más información cómodamente.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 10) // Espaciado vertical para que el fondo blanco se vea más estético
                    .background(Color.white) // Fondo blanco
                    .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255)) // Color de texto principal
                    .cornerRadius(8)

                if let phone = tourist.telefono1 {
                    Button(action: {
                        // Acción para llamar
                        if let url = URL(string: "tel:\(phone)"), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                            Text("Llamar")
                        }
                        .font(.headline)  // Aumenta el tamaño del texto
                        .padding()
                        .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2)  // Borde blanco
                        )
                    }
                }
                /*
                if let email = tourist.email {
                    Button(action: {
                            self.sendEmailViaFirebase()
                        }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white)
                            Text("Enviar email")
                        }
                        .font(.headline)
                        .padding()
                        .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2)
                        )
                    }
                }
                */
                if let email = tourist.email {
                    Button(action: {
                        self.isMailViewShowing = true
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white)
                            Text("Enviar email")
                        }
                        .font(.headline)  // Aumenta el tamaño del texto
                        .padding()
                        .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white, lineWidth: 2)  // Borde blanco
                        )
                    }
                    .sheet(isPresented: $isMailViewShowing) {
                        VStack(spacing: 20) {
                            Text("Escribe tu mensaje:")
                            TextField("Mensaje", text: $emailMessage)
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding(.horizontal)
                            Button("Enviar", action: self.sendEmailViaFirebase)
                                .padding()
                                .background(Color(red: 39/255, green: 73/255, blue: 106/255))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }


            }
            .padding()
        }
        .alert(isPresented: $showEmailOptions) { // Alerta añadida de no tener email en Mail de Apple
            Alert(title: Text("Error"),
                  message: Text("No puedes enviar correos desde este dispositivo. Asegúrate de tener una cuenta de correo configurada en la app Mail de Apple."),
                  dismissButton: .default(Text("Ok")))
        }
    }
}
//PRUEBA MENSAJES DESDE SWIFTUI SIN USAR UIKIT
extension ContactView {
    
    private class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
    private func sendEmailViaFirebase() {
        guard let user = Auth.auth().currentUser, let userEmail = user.email else {
            print("Error: No se pudo obtener la información del usuario.")
            return
        }
        
        let message = emailMessage  // Usamos la variable que guarda el mensaje escrito por el usuario
        
        let functions = Functions.functions()
        functions.httpsCallable("sendEmail").call(["userEmail": userEmail, "destinationEmail": tourist.email ?? "", "message": message]) { (result, error) in
            if let error = error as NSError? {
                print("Error al enviar el correo: \(error.localizedDescription)")
            }
            
            if let success = (result?.data as? [String: Any])?["success"] as? Bool, success {
                print("Correo enviado exitosamente.")
            } else {
                print("Error al enviar el correo.")
            }
        }
    }



    
}




/*
struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyTourist = TouristModel(
            id: "dummyID",
            registro: "",
            categoria: "",
            tipo: "",
            nombre: "Tourist Place",
            direccion: "",
            cPostal: 12345,
            provincia: "",
            municipio: "",
            localidad: "",
            nucleo: "",
            telefono1: 123456789,
            telefono2: nil,
            telefono3: nil,
            email: "test@email.com",
            web: "",
            qCalidad: "",
            longitud: 50.123456,
            latitud: -0.987654
        )
        return ContactView(tourist: dummyTourist)
    }
}
*/
