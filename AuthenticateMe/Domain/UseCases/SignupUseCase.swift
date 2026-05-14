//
//  SignupUseCase.swift
//  AuthenticateMe
//

import Foundation

// MARK: - SignupUseCase

/// Coordinates signup through the authentication repository.
struct SignupUseCase: Sendable {
    private let repository: AuthenticationRepositoryProtocol

    init(repository: AuthenticationRepositoryProtocol) {
        self.repository = repository
    }

    func execute(firstName: String, lastName: String, email: String, password: String) async throws -> User {
        try await repository.signup(firstName: firstName, lastName: lastName, email: email, password: password)
    }
}
