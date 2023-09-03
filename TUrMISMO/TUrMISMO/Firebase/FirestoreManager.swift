//
//  FirestoreManager.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 31/8/23.
//

import Foundation
import FirebaseFirestore

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

    /*
     
     //FUNCIONA PERFECTAMENTE
    func getTouristData(completion: @escaping ([TouristModel]) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("dataTurismoJCyL")

        collectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])
            } else {
                let models = querySnapshot?.documents.compactMap { document in
                    return TouristModel(document: document)
                } ?? []
                completion(models)
            }
        }
    }
     */
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
                    print("Document ID: \(document.documentID), C.Postal: \(document.get("C.Postal") ?? "No disponible")")
                }
                
                let models = querySnapshot?.documents.compactMap { document in
                    return TouristModel(document: document)
                } ?? []

                completion(models)
            }
        }
    }


    

}
