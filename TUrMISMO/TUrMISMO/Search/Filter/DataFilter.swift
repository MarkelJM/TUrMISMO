//
//  DataFilter.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 1/9/23.
//

import Foundation

class DataFilter {
    func filterTouristData(touristModels: [TouristModel], provincia: String, tipo: String) -> [TouristModel] {
        return touristModels.filter { $0.provincia == provincia && $0.tipo == tipo }
    }
}
