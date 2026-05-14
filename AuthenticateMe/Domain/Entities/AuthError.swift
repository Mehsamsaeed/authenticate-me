//
//  AuthError.swift
//  AuthenticateMe
//

import Foundation

// MARK: - AuthError

/// Domain-level authentication failures surfaced to the presentation layer.
enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case emailAlreadyRegistered
    case networkUnavailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return String(localized: "auth.error.invalidCredentials", bundle: .main)
        case .emailAlreadyRegistered:
            return String(localized: "auth.error.emailAlreadyRegistered", bundle: .main)
        case .networkUnavailable:
            return String(localized: "auth.error.networkUnavailable", bundle: .main)
        case .unknown:
            return String(localized: "auth.error.unknown", bundle: .main)
        }
    }
}
