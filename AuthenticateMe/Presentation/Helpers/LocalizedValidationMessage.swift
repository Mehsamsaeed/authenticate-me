//
//  LocalizedValidationMessage.swift
//  AuthenticateMe
//

import Foundation

// MARK: - LocalizedValidationMessage

enum LocalizedValidationMessage {
    static func message(for error: EmailValidationError?) -> String? {
        guard let error else { return nil }
        switch error {
        case .empty:
            return String(localized: "validation.email.empty", bundle: .main)
        case .invalidFormat:
            return String(localized: "validation.email.invalid", bundle: .main)
        }
    }

    static func message(for error: PasswordValidationError?) -> String? {
        guard let error else { return nil }
        switch error {
        case .empty:
            return String(localized: "validation.password.empty", bundle: .main)
        case .tooShort:
            return String(localized: "validation.password.tooShort", bundle: .main)
        case .missingUppercase:
            return String(localized: "validation.password.missingUppercase", bundle: .main)
        case .missingLowercase:
            return String(localized: "validation.password.missingLowercase", bundle: .main)
        case .missingNumber:
            return String(localized: "validation.password.missingNumber", bundle: .main)
        case .missingSpecialCharacter:
            return String(localized: "validation.password.missingSpecial", bundle: .main)
        }
    }

    static func message(for error: NameValidationError?) -> String? {
        guard let error else { return nil }
        switch error {
        case .empty:
            return String(localized: "validation.name.empty", bundle: .main)
        }
    }

    static func message(for error: ConfirmPasswordValidationError?) -> String? {
        guard let error else { return nil }
        switch error {
        case .mismatch:
            return String(localized: "validation.confirmPassword.mismatch", bundle: .main)
        }
    }

    static func message(for error: AuthError) -> String {
        switch error {
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
