//
//  UserData+Firebase.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 10/9/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


extension UserData {
    // Usar el id del documento directamente en lugar de extraerlo del diccionario de datos
    init?(documentId: String, documentData: [String: Any]) {
        guard let email = documentData["email"] as? String,
              let favoriteCompanies = documentData["favoriteCompanies"] as? [String] else {
            return nil
        }
        self.id = documentId
        self.email = email
        self.favoriteCompanies = favoriteCompanies
    }
    
    var documentData: [String: Any] {
        return [
            "email": email,
            "favoriteCompanies": favoriteCompanies
        ]
    }
}
