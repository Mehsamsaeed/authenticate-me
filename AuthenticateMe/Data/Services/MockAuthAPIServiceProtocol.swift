//
//  MockAuthAPIServiceProtocol.swift
//  AuthenticateMe
//

import Foundation

// MARK: - MockAuthAPIServiceProtocol

/// Async authentication API suitable for mocking and UI tests.
protocol MockAuthAPIServiceProtocol: Sendable {
    func login(request: LoginRequestDTO) async throws -> AuthResponseDTO
    func signup(request: SignupRequestDTO) async throws -> AuthResponseDTO
}
