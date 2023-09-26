//
//  AddCommentView.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 22/9/23.
//
import SwiftUI
import FirebaseAuth

struct AddCommentView: View {
    @State private var commentText = ""
    @State private var commentName = ""
    @State private var rating: Int = 5
    var touristId: String
    @State private var showAlert = false
    @Binding var isSheetPresented: Bool

    
    // Auth para obtener el UID del usuario autenticado.
    var userId: String? {
        return Auth.auth().currentUser?.uid
    }
    var userEmail: String? {
        return Auth.auth().currentUser?.email
    }

    var body: some View {
        ZStack {
            // Fondo
            Image("fondoApp")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                
                // Texto descriptivo
                Text("Deja un comentario y cuéntanos tu experiencia con la empresa.")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.vertical, 10) // Espaciado vertical para que el fondo blanco se vea más estético
                    .background(Color.white) // Fondo blanco
                    .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255)) // Color de texto principal
                    .cornerRadius(8)
                
                TextField("Escribe tu comentario", text: $commentText)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.top, 60)
                
                TextField("Indica tu nombre", text: $commentName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                
                Stepper(value: $rating, in: 1...5) {
                    Text("Rating: \(rating)")
                        .foregroundColor(Color(red: 39/255, green: 73/255, blue: 106/255))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal)
                
                Button(action: {
                    guard let userId = userId, let userEmail = userEmail else {
                        print("No se pudo obtener el userId o el email del usuario")
                        return
                    }

                    let newComment = CommentModel(userId: userId,
                                                  userName: commentName,
                                                  userEmail: userEmail,
                                                  text: commentText,
                                                  rating: rating,
                                                  date: Date(),
                                                  touristId: touristId)

                    FirestoreManager().addComment(forCompany: touristId, comment: newComment) { success, error in
                            if success {
                                print("Comentario agregado exitosamente!")
                                showAlert = true  // Mostrar la alerta
                            } else {
                                print("Error al agregar comentario: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }                }) {
                    Text("Enviar comentario")
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Comentario enviado"),
                          message: Text("¡Gracias por tu comentario!"),
                          dismissButton: .default(Text("Aceptar")) {
                              isSheetPresented = false  // Cierra el .sheet
                          })
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
            .padding()
        }
    }
}

struct AddCommentView_Previews: PreviewProvider {
    @State static var isSheetPresented = true  

    static var previews: some View {
        AddCommentView(touristId: "sampleId", isSheetPresented: $isSheetPresented)
    }
}
