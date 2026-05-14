//
//  AuthenticationRepositoryProtocol.swift
//  AuthenticateMe
//

import Foundation

// MARK: - AuthenticationRepositoryProtocol

/// Abstraction over remote authentication operations.
protocol AuthenticationRepositoryProtocol: Sendable {
    /// Performs login with the supplied credentials.
    func login(email: String, password: String) async throws -> User

    /// Registers a new account and returns the created user.
    func signup(firstName: String, lastName: String, email: String, password: String) async throws -> User
}
