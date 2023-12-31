//
//  MapViewModel.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//
import Foundation
import Combine
import MapKit
import _MapKit_SwiftUI

class MapViewModel: ObservableObject {
    @Published var allLugaresTuristicos: [TouristModel] = []
    @Published var filteredLugaresTuristicos: [TouristModel] = []
    @Published var userTrackingMode: MapUserTrackingMode = .follow
    
    private var firestoreManager = FirestoreManager()
    // Cargar los datos de lugares turísticos y filtrar aquellos que tienen nil como latitud o longitud

    func cargarDatos() {
        firestoreManager.getTouristData { datos in
            // Filtrar los lugares turísticos que tienen latitud y longitud no nulas

            self.allLugaresTuristicos = datos.filter { $0.latitud != nil && $0.longitud != nil }
            self.filterData()
        }
    }
    
    func filterData(searchText: String = "", provincia: String = "", tipo: String = "") {
        // Filtrar los datos basados en el texto de búsqueda, la provincia y el tipo

        self.filteredLugaresTuristicos = self.allLugaresTuristicos.filter { lugar in
            let matchesSearchText = searchText.isEmpty || lugar.nombre?.contains(searchText) ?? false
            let matchesProvincia = provincia.isEmpty || provincia == Provincias.todos.rawValue || lugar.provincia == provincia
            let matchesTipo = tipo.isEmpty || tipo == Tipo.todos.rawValue || lugar.tipo == tipo
            return matchesSearchText && matchesProvincia && matchesTipo
        }
    }

}




