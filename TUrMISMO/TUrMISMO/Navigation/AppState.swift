//
//  AppState.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 9/9/23.
//

import Foundation


class AppState: ObservableObject {
    @Published var currentView: AppView = .onboarding

    enum AppView {
        case onboarding
        case login
        case register
        case emailVerification
        case touristList
    }
}

