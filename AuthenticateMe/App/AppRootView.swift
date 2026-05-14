//
//  AppRootView.swift
//  AuthenticateMe
//

import SwiftUI

// MARK: - AppRootView

/// Root SwiftUI hierarchy switching between authentication and the home experience.
@MainActor
struct AppRootView: View {
    @StateObject private var coordinator: AppCoordinator

    init() {
        _coordinator = StateObject(wrappedValue: CompositionRoot.makeAppCoordinator())
    }

    var body: some View {
        Group {
            if let user = coordinator.userSession {
                HomeView(user: user, onSignOut: { coordinator.signOut() })
            } else {
                AuthCoordinatorView(coordinator: coordinator.authCoordinator)
            }
        }
    }
}

#Preview {
    AppRootView()
}
