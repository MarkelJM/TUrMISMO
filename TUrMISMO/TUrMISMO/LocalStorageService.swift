//
//  LocalStorageService.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 11/9/23.
//

import Foundation
import Combine

class LocalStorageService {
    static let shared = LocalStorageService()

    private let favoritesKey = "favorites"
    
    let favoritesChanged = PassthroughSubject<Void, Never>()

    func addFavoriteCompany(companyID: String) {
        var favorites = getFavoriteCompanies()
        favorites.append(companyID)
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
        favoritesChanged.send()
    }

    func removeFavoriteCompany(companyID: String) {
        var favorites = getFavoriteCompanies()
        if let index = favorites.firstIndex(of: companyID) {
            favorites.remove(at: index)
        }
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
        favoritesChanged.send()
    }

    func getFavoriteCompanies() -> [String] {
        return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
}
