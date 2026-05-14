//
//  AuthResponseDTO.swift
//  AuthenticateMe
//

import Foundation

// MARK: - AuthResponseDTO

struct AuthResponseDTO: Decodable, Sendable {
    let userId: String
    let email: String
    let firstName: String
    let lastName: String

    func toDomain() -> User {
        User(id: userId, email: email, firstName: firstName, lastName: lastName)
    }
}
