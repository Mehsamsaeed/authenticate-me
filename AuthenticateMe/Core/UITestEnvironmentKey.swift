//
//  UITestEnvironmentKey.swift
//  AuthenticateMe
//

import Foundation

// MARK: - UITestEnvironmentKey

/// Environment keys consumed by `XCUIApplication.launchEnvironment` in UI tests.
enum UITestEnvironmentKey: String {
    case fastDelay = "UITEST_FAST_DELAY"
    /// Renders password entry as a plain `TextField` so XCTest typing is reliable (`SecureField` often truncates input).
    case plainTextPasswordFields = "UITEST_PLAIN_TEXT_PASSWORDS"
    case loginFail = "UITEST_LOGIN_FAIL"
    case signupFail = "UITEST_SIGNUP_FAIL"
    case networkFail = "UITEST_NETWORK_FAIL"
}
