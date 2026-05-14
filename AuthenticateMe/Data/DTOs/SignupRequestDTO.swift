//
//  SignupRequestDTO.swift
//  AuthenticateMe
//

import Foundation

// MARK: - SignupRequestDTO

struct SignupRequestDTO: Encodable, Sendable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
