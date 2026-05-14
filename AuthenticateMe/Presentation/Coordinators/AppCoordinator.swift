//
//  AppCoordinator.swift
//  AuthenticateMe
//

import Combine
import Foundation

// MARK: - AppCoordinator

/// Root coordinator managing authenticated vs unauthenticated phases.
@MainActor
final class AppCoordinator: ObservableObject {
    @Published private(set) var userSession: User?

    /// Eagerly created so SwiftUI never triggers lazy resolution during the first layout pass.
    let authCoordinator: AuthCoordinator

    init(dependencies: AppDependencies) {
        let relay = AuthSessionRelay()
        self.authCoordinator = AuthCoordinator(
            dependencies: dependencies,
            onAuthenticated: { user in
                relay.apply(user)
            }
        )
        relay.appCoordinator = self
    }

    func signOut() {
        userSession = nil
    }

    /// Used by `AuthSessionRelay` so `init` can avoid capturing `self` before `authCoordinator` exists.
    fileprivate func applyAuthenticatedSession(_ user: User) {
        userSession = user
    }
}

// MARK: - AuthSessionRelay

/// Breaks the `self`-before-initialization cycle when wiring `AuthCoordinator` into `AppCoordinator`.
@MainActor
private final class AuthSessionRelay {
    weak var appCoordinator: AppCoordinator?

    func apply(_ user: User) {
        appCoordinator?.applyAuthenticatedSession(user)
    }
}
