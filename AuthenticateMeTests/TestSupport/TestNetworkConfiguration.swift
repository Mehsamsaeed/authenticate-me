//
//  TestNetworkConfiguration.swift
//  AuthenticateMeTests
//

import Foundation
@testable import AuthenticateMe

// MARK: - TestNetworkConfiguration

enum TestNetworkConfiguration {
    static func instantSuccess() -> NetworkSimulationConfiguration {
        NetworkSimulationConfiguration(
            delaySeconds: 0,
            forceLoginFailure: false,
            forceSignupFailure: false,
            forceNetworkFailure: false,
            blockedEmails: ["taken@example.com"]
        )
    }

    static func instantLoginFailure() -> NetworkSimulationConfiguration {
        NetworkSimulationConfiguration(
            delaySeconds: 0,
            forceLoginFailure: true,
            forceSignupFailure: false,
            forceNetworkFailure: false,
            blockedEmails: ["taken@example.com"]
        )
    }

    static func instantSignupFailure() -> NetworkSimulationConfiguration {
        NetworkSimulationConfiguration(
            delaySeconds: 0,
            forceLoginFailure: false,
            forceSignupFailure: true,
            forceNetworkFailure: false,
            blockedEmails: ["taken@example.com"]
        )
    }

    static func instantNetworkFailure() -> NetworkSimulationConfiguration {
        NetworkSimulationConfiguration(
            delaySeconds: 0,
            forceLoginFailure: false,
            forceSignupFailure: false,
            forceNetworkFailure: true,
            blockedEmails: ["taken@example.com"]
        )
    }
}
