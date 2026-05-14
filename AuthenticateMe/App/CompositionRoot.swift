//
//  CompositionRoot.swift
//  AuthenticateMe
//

import Foundation

// MARK: - CompositionRoot

/// Central factory for application-level objects.
enum CompositionRoot {
    @MainActor
    static func makeAppCoordinator(dependencies: AppDependencies = .live()) -> AppCoordinator {
        AppCoordinator(dependencies: dependencies)
    }
}
