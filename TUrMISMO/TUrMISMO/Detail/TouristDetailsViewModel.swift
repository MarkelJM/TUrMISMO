//
//  TouristDetailsViewModel.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 11/9/23.
//

import Foundation
import Combine

class TouristDetailViewModel: ObservableObject {
    var tourist: TouristModel
    @Published var favorites: [String] = []

    private var cancellables = Set<AnyCancellable>()

    init(tourist: TouristModel) {
        self.tourist = tourist
        
        // Carga los favoritos iniciales.
        self.favorites = LocalStorageService.shared.getFavoriteCompanies()
        
        // Escucha los cambios en los favoritos.
        LocalStorageService.shared.favoritesChanged
            .sink(receiveValue: { [weak self] in
                self?.favorites = LocalStorageService.shared.getFavoriteCompanies()
            })
            .store(in: &cancellables)
    }

    func toggleFavorite(company: TouristModel) {
        let companyID = company.id
        if isFavorite(company: company) {
            LocalStorageService.shared.removeFavoriteCompany(companyID: companyID)
        } else {
            LocalStorageService.shared.addFavoriteCompany(companyID: companyID)
        }
        favorites = LocalStorageService.shared.getFavoriteCompanies()
    }

    func isFavorite(company: TouristModel) -> Bool {
        return favorites.contains(company.id)
    }
}
