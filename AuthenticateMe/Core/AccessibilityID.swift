//
//  AccessibilityID.swift
//  AuthenticateMe
//

import Foundation

// MARK: - AccessibilityID

/// Centralized accessibility identifiers for UI tests and assistive technologies.
enum AccessibilityID {
    enum Login {
        static let emailField = "login.email.field"
        static let passwordField = "login.password.field"
        static let loginButton = "login.submit.button"
        static let forgotPasswordButton = "login.forgotPassword.button"
        static let goToSignupLink = "login.goToSignup.link"
        static let errorBanner = "login.error.banner"
    }

    enum Signup {
        static let firstNameField = "signup.firstName.field"
        static let lastNameField = "signup.lastName.field"
        static let emailField = "signup.email.field"
        static let passwordField = "signup.password.field"
        static let confirmPasswordField = "signup.confirmPassword.field"
        static let createAccountButton = "signup.submit.button"
        static let backToLoginLink = "signup.backToLogin.link"
        static let errorBanner = "signup.error.banner"
    }

    enum Home {
        static let title = "home.title"
        static let subtitle = "home.subtitle"
        static let signOutButton = "home.signOut.button"
    }
}
