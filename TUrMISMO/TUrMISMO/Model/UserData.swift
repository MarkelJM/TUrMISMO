//
//  UserData.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 10/9/23.
//

import Foundation


struct UserData {
    var id: String
    var email: String
    var favoriteCompanies: [String]
}

class SharedFavorites: ObservableObject {
    @Published var favorites: [String] = [] 
}

