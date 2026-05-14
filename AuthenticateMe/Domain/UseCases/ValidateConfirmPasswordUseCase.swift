//
//  ValidateConfirmPasswordUseCase.swift
//  AuthenticateMe
//

import Foundation

// MARK: - ConfirmPasswordValidationError

enum ConfirmPasswordValidationError: Equatable, Sendable {
    case mismatch
}

// MARK: - ValidateConfirmPasswordUseCase

/// Ensures confirmation matches the primary password after trimming.
struct ValidateConfirmPasswordUseCase: Sendable {
    /// Returns `nil` when passwords match (including both empty, which higher-level rules may reject separately).
    func execute(password: String, confirmPassword: String) -> ConfirmPasswordValidationError? {
        let p = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let c = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
        if p != c { return .mismatch }
        return nil
    }
}
