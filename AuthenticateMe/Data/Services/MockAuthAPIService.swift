//
//  MockAuthAPIService.swift
//  AuthenticateMe
//

import Foundation

// MARK: - MockAuthAPIService

/// Simulated network authentication with configurable delay and UI-test hooks.
struct MockAuthAPIService: MockAuthAPIServiceProtocol {
    private let configuration: NetworkSimulationConfiguration

    init(configuration: NetworkSimulationConfiguration = .default) {
        self.configuration = configuration
    }

    func login(request: LoginRequestDTO) async throws -> AuthResponseDTO {
        try await simulateDelay()
        if configuration.forceLoginFailure {
            throw AuthError.invalidCredentials
        }
        return AuthResponseDTO(
            userId: "login-\(request.email.lowercased())",
            email: request.email.trimmingCharacters(in: .whitespacesAndNewlines),
            firstName: "Signed",
            lastName: "In"
        )
    }

    func signup(request: SignupRequestDTO) async throws -> AuthResponseDTO {
        try await simulateDelay()
        if configuration.forceSignupFailure {
            throw AuthError.emailAlreadyRegistered
        }
        let email = request.email.trimmingCharacters(in: .whitespacesAndNewlines)
        if configuration.blockedEmails.contains(email.lowercased()) {
            throw AuthError.emailAlreadyRegistered
        }
        return AuthResponseDTO(
            userId: UUID().uuidString,
            email: email,
            firstName: request.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
            lastName: request.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        )
    }
}

// MARK: - Private

private extension MockAuthAPIService {
    func simulateDelay() async throws {
        let nanoseconds = UInt64(configuration.delaySeconds * 1_000_000_000)
        if nanoseconds > 0 {
            try await Task.sleep(nanoseconds: nanoseconds)
        }
        if configuration.forceNetworkFailure {
            throw AuthError.networkUnavailable
        }
    }
}

// MARK: - NetworkSimulationConfiguration

/// Controls mock latency and failure modes for tests and previews.
struct NetworkSimulationConfiguration: Sendable {
    var delaySeconds: TimeInterval
    var forceLoginFailure: Bool
    var forceSignupFailure: Bool
    var forceNetworkFailure: Bool
    var blockedEmails: Set<String>

    static let `default`: NetworkSimulationConfiguration = {
        let env = ProcessInfo.processInfo.environment
        let uiTestFast = env[UITestEnvironmentKey.fastDelay.rawValue] == "1"
        let delay: TimeInterval = uiTestFast ? 0.01 : 0.65
        return NetworkSimulationConfiguration(
            delaySeconds: delay,
            forceLoginFailure: env[UITestEnvironmentKey.loginFail.rawValue] == "1",
            forceSignupFailure: env[UITestEnvironmentKey.signupFail.rawValue] == "1",
            forceNetworkFailure: env[UITestEnvironmentKey.networkFail.rawValue] == "1",
            blockedEmails: ["taken@example.com"]
        )
    }()
}
