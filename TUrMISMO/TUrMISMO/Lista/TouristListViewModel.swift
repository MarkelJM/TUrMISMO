//
//  TouristListViewModel.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//

import Foundation
import Combine
import FirebaseFirestore
import SwiftUI

class TouristListViewModel: ObservableObject {
    @Published var allTouristModels: [TouristModel] = []
    @Published var touristModels: [TouristModel] = []
    @Published var searchText: String = ""
    @Published var selectedProvincia: String = Provincias.todos.rawValue
    @Published var selectedTipo: String = Tipo.todos.rawValue
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchTouristData()
        
        Publishers.CombineLatest3($searchText, $selectedProvincia, $selectedTipo)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] in self?.filterData(searchText: $0, provincia: $1, tipo: $2) }
            .store(in: &cancellables)
    }
    
    func fetchTouristData() {
        FirestoreManager().getTouristData { [weak self] models in
            self?.allTouristModels = models
            self?.touristModels = models
        }
    }
    
    private func filterData(searchText: String, provincia: String, tipo: String) {
        var filteredModels = allTouristModels
        
        if !searchText.isEmpty {
            filteredModels = filteredModels.filter { $0.nombre?.contains(searchText) ?? false }
        }
        
        if provincia != Provincias.todos.rawValue {
            filteredModels = filteredModels.filter { $0.provincia == provincia }
        }
        
        if tipo != Tipo.todos.rawValue {
            filteredModels = filteredModels.filter { $0.tipo == tipo }
        }
        
        touristModels = filteredModels
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

