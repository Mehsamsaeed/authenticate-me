//
//  LoginUseCase.swift
//  AuthenticateMe
//

import Foundation

// MARK: - LoginUseCase

/// Coordinates login through the authentication repository.
struct LoginUseCase: Sendable {
    private let repository: AuthenticationRepositoryProtocol

    init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws -> User {
        try await repository.login(email: email, password: password)
    }
}
