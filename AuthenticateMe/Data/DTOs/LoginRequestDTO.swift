//
//  LoginRequestDTO.swift
//  AuthenticateMe
//

import Foundation

// MARK: - LoginRequestDTO

struct LoginRequestDTO: Encodable, Sendable {
    let email: String
    let password: String
}
