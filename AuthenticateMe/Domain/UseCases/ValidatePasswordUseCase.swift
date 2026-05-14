//
//  ValidatePasswordUseCase.swift
//  AuthenticateMe
//

import Foundation

// MARK: - PasswordValidationKind

enum PasswordValidationKind: Sendable {
    /// Login: password must be non-empty after trimming.
    case login
    /// Signup: password strength rules apply.
    case signup
}

// MARK: - PasswordValidationError

enum PasswordValidationError: Equatable, Sendable {
    case empty
    case tooShort
    case missingUppercase
    case missingLowercase
    case missingNumber
    case missingSpecialCharacter
}

// MARK: - ValidatePasswordUseCase

/// Validates passwords for login (presence) or signup (strength).
struct ValidatePasswordUseCase: Sendable {
    private let kind: PasswordValidationKind

    init(kind: PasswordValidationKind) {
        self.kind = kind
    }

    /// Returns `nil` when valid, otherwise the first validation error encountered.
    func execute(password: String) -> PasswordValidationError? {
        let trimmed = password.trimmingCharacters(in: .whitespacesAndNewlines)
        switch kind {
        case .login:
            if trimmed.isEmpty { return .empty }
            return nil
        case .signup:
            return validateSignupPassword(trimmed)
        }
    }
}

// MARK: - Private

private extension ValidatePasswordUseCase {
    static let minimumLength = 8
    static let specialScalars = CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:',.<>?/`~")

    func validateSignupPassword(_ password: String) -> PasswordValidationError? {
        if password.isEmpty { return .empty }
        if password.count < Self.minimumLength { return .tooShort }
        if !password.contains(where: { $0.isUppercase }) { return .missingUppercase }
        if !password.contains(where: { $0.isLowercase }) { return .missingLowercase }
        if !password.contains(where: { $0.isNumber }) { return .missingNumber }
        let containsSpecial = password.unicodeScalars.contains { Self.specialScalars.contains($0) }
        if !containsSpecial { return .missingSpecialCharacter }
        return nil
    }
}
