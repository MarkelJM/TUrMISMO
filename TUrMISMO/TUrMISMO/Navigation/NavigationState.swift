//
//  NavigationState.swift
//  TUrMISMO
//
//  Created by Markel Juaristi on 9/9/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        switch appState.currentView {
        case .onboarding:
            OnboardingView(appState: appState)
        case .login:
            LoginView(appState: appState)
        case .register:
            RegisterView()
        case .emailVerification:
            EmailVerificationView()
        case .touristList:
            TabBarView()
        }
    }
}


