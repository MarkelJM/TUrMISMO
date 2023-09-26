//
//  FavoritosViewModel.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 10/9/23.
//

import Foundation
import Combine
import SwiftUI
import CoreLocation


class FavoritosViewModel: ObservableObject {
    @Published var favoriteCompanies = [TouristModel]()
    private var allCompanies = [TouristModel]()
    private let firestoreManager = FirestoreManager()
    private let favoritesChanged = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()


    init() {
        fetchAllCompanies()
        favoritesChanged
            .sink { [weak self] in self?.fetchFavorites() }
            .store(in: &cancellables)
    }

    func isFavorite(company: TouristModel) -> Bool {
        return favoriteCompanies.contains(where: { $0.id == company.id })
    }

    func toggleFavorite(company: TouristModel) {
        let companyID = company.id
        if isFavorite(company: company) {
            LocalStorageService.shared.removeFavoriteCompany(companyID: companyID)
        } else {
            LocalStorageService.shared.addFavoriteCompany(companyID: companyID)
        }
        favoritesChanged.send()  // Esto invocará fetchFavorites gracias a la suscripción en el init
    }




    private func fetchAllCompanies() {
        firestoreManager.getTouristData { companies in
            DispatchQueue.main.async {
                self.allCompanies = companies
                self.fetchFavorites()
            }
        }
    }

    func fetchFavorites() {
        let favoriteCompanyIDs = LocalStorageService.shared.getFavoriteCompanies()
        DispatchQueue.main.async {
            self.favoriteCompanies = self.allCompanies.filter {
                favoriteCompanyIDs.contains($0.id ?? "")
            }
        }
    }
    
    func getImageForTipo(tipo: String) -> Image {
        switch tipo {
        case Tipo.montaña.rawValue:
            return Image(systemName: "mountain.fill")
        case Tipo.golf.rawValue:
            return Image(systemName: "golfcourse.fill")
        case Tipo.transporte.rawValue:
            return Image(systemName: "car.fill")
        case Tipo.congresos.rawValue:
            return Image(systemName: "person.3.fill")
        case Tipo.termasOtrosEstablecimientos.rawValue:
            return Image(systemName: "drop.fill")
        case Tipo.bodegasEnoturismo.rawValue:
            return Image(systemName: "wineglass.fill")
        case Tipo.catering.rawValue:
            return Image(systemName: "tray.full.fill")
        case Tipo.enseñanzaEspañol.rawValue:
            return Image(systemName: "book.fill")
        case Tipo.areaServicio.rawValue:
            return Image(systemName: "gear")
        case Tipo.parquesTematicos.rawValue:
            return Image(systemName: "amusementpark")
        case Tipo.patrimionioCultural.rawValue:
            return Image(systemName: "building.columns.fill")
        case Tipo.infoTurisitca.rawValue:
            return Image(systemName: "info.circle.fill")
        case Tipo.acuaticas.rawValue:
            return Image(systemName: "tropicalstorm")
        case Tipo.ambientalCaza.rawValue:
            return Image(systemName: "leaf.fill")
        case Tipo.interpretacion.rawValue:
            return Image(systemName: "map.fill")
        case Tipo.artesanalesTraciciones.rawValue:
            return Image(systemName: "paintpalette.fill")
        case Tipo.actividadesrecreativas.rawValue:
            return Image(systemName: "gamecontroller.fill")
        case Tipo.tecnologiaTuristica.rawValue:
            return Image(systemName: "desktopcomputer")
        case Tipo.turismoActivo.rawValue:
            return Image(systemName: "bicycle")
        case Tipo.otrasActividades.rawValue:
            return Image(systemName: "star.fill")
        default:
            return Image(systemName: "questionmark.circle")
        }
    }
    
    

}
