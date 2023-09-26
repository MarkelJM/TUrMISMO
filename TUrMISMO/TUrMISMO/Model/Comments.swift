//
//  Comments.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 22/9/23.
//

import Foundation
import FirebaseFirestore

struct CommentModel: Identifiable {
    var id: String?
    var userId: String
    var userName: String
    var userEmail: String
    var text: String
    var rating: Int
    var date: Date
    var touristId: String
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        self.userId = document["userId"] as? String ?? ""
        self.userName = document["userName"] as? String ?? ""
        self.userEmail = document["userEmail"] as? String ?? ""
        self.text = document["text"] as? String ?? ""
        self.rating = document["rating"] as? Int ?? 0
        self.date = document["date"] as? Date ?? Date()
        self.touristId = document["touristId"] as? String ?? ""
    }
    
    init(userId: String, userName: String, userEmail: String, text: String, rating: Int, date: Date, touristId: String) {
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
        self.text = text
        self.rating = rating
        self.date = date
        self.touristId = touristId
    }
}
