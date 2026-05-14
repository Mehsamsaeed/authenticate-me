//
//  ValidateEmailUseCase.swift
//  AuthenticateMe
//

import Foundation

// MARK: - EmailValidationError

enum EmailValidationError: Equatable, Sendable {
    case empty
    case invalidFormat
}

// MARK: - ValidateEmailUseCase

/// Validates email presence and RFC-inspired format checks suitable for client-side UX.
struct ValidateEmailUseCase: Sendable {
    private let predicate: NSPredicate

    init() {
        self.predicate = NSPredicate(format: "SELF MATCHES %@", ValidateEmailUseCase.emailRegexPattern)
    }

    /// Returns `nil` when valid, otherwise the first validation error encountered.
    func execute(email: String) -> EmailValidationError? {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return .empty }
        if !predicate.evaluate(with: trimmed) { return .invalidFormat }
        return nil
    }
}

// MARK: - Private

private extension ValidateEmailUseCase {
    /// Practical client-side pattern; not a full RFC parser.
    static let emailRegexPattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
}
