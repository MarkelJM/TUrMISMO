//
//  FirestoreManager.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 31/8/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    
    func getOneData(documentID: String, completion: @escaping (TouristModel?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("dataTurismoJCyL").document(documentID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let touristModel = TouristModel(document: document)
                completion(touristModel)
            } else {
                print("Document does not exist: \(error?.localizedDescription ?? "")")
                completion(nil)
            }
        }
    }

    
    func getTouristData(completion: @escaping ([TouristModel]) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("dataTurismoJCyL")

        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                querySnapshot?.documents.forEach { document in
                    // Imprimir el código postal de este documento
                    //print("Document ID: \(document.documentID), C.Postal: \(document.get("C.Postal") ?? "No disponible")")
                }
                
                let models = querySnapshot?.documents.compactMap { document in
                    return TouristModel(document: document)
                } ?? []

                completion(models)
            }
        }
    }
    
    
    func getComments(forCompany companyID: String, completion: @escaping ([CommentModel]) -> Void) {
        let db = Firestore.firestore()
        
        // Obtener referencia a la subcolección de comentarios para la empresa
        let companyCommentsRef = db.collection("comments").document(companyID).collection("userComments")
        
        companyCommentsRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error al obtener comentarios: \(error.localizedDescription)")
                completion([])
            } else {
                let comments = querySnapshot?.documents.compactMap { document in
                    return CommentModel(document: document)
                } ?? []
                
                completion(comments)
            }
        }
    }

    
    func addComment(forCompany companyId: String, comment: CommentModel, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        
        // Convertimos el modelo a un diccionario para guardar en Firestore
        let commentData: [String: Any] = [
            "userId": comment.userId,
            "userName": comment.userName,
            "userEmail": comment.userEmail,
            "text": comment.text,
            "rating": comment.rating,
            "date": comment.date,
            "touristId": comment.touristId
        ]
        
        // Aquí usamos el companyId para acceder a la subcolección "comments" de esa empresa
        let companyCommentsRef = db.collection("comments").document(companyId).collection("userComments")
        
        // Añade el comentario a la subcolección. Firestore generará automáticamente un ID único para el nuevo documento.
        companyCommentsRef.addDocument(data: commentData) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    ///ORDENAR POR PUNTUACION
    // Esta función obtendrá el promedio de calificación para una empresa
        func getAverageRating(forCompany companyID: String, completion: @escaping (Double?) -> Void) {
            getComments(forCompany: companyID) { comments in
                let totalRating = comments.reduce(0) { $0 + $1.rating }
                
                // Si no hay comentarios, se retorna nil
                let averageRating = comments.isEmpty ? nil : Double(totalRating) / Double(comments.count)
                
                completion(averageRating)
            }
        }
        
        // Esta función devolverá las empresas ordenadas según sus calificaciones promedio
        func getTouristDataOrderedByRating(completion: @escaping ([TouristModel]) -> Void) {
            getTouristData { touristModels in
                // Crear un grupo para manejar múltiples solicitudes
                let group = DispatchGroup()
                
                // Diccionario para almacenar el promedio de calificación para cada empresa
                var ratingDict: [String: Double] = [:]
                
                for model in touristModels {
                    group.enter()
                    self.getAverageRating(forCompany: model.id) { averageRating in
                        if let rating = averageRating {
                            ratingDict[model.id] = rating
                        }
                        group.leave()
                    }
                }
                
                // Una vez que todas las solicitudes han sido procesadas...
                group.notify(queue: .main) {
                    // Ordenar las empresas por calificación. Aquellas sin calificación serán consideradas con valor -1 para que vayan al final
                    let orderedModels = touristModels.sorted {
                        let rating1 = ratingDict[$0.id] ?? -1
                        let rating2 = ratingDict[$1.id] ?? -1
                        return rating1 > rating2
                    }
                    completion(orderedModels)
                }
            }
        }


    

   

}
