//
//  User.swift
//  AuthenticateMe
//
//  Domain entity representing an authenticated user session.
//

import Foundation

// MARK: - User

/// Authenticated user returned by the authentication domain.
struct User: Equatable, Sendable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
}
