//
//  ValidateNameUseCase.swift
//  AuthenticateMe
//

import Foundation

// MARK: - NameValidationError

enum NameValidationError: Equatable, Sendable {
    case empty
}

// MARK: - ValidateNameUseCase

/// Validates required person name fields (first or last name).
struct ValidateNameUseCase: Sendable {
    /// Returns `nil` when valid, otherwise `.empty`.
    func execute(name: String) -> NameValidationError? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .empty }
        return nil
    }
}
