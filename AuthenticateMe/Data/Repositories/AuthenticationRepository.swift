//
//  AuthenticationRepository.swift
//  AuthenticateMe
//

import Foundation

// MARK: - AuthenticationRepository

/// Maps DTOs to domain models and forwards calls to the API service.
struct AuthenticationRepository: AuthenticationRepositoryProtocol {
    private let apiService: MockAuthAPIServiceProtocol

    init(apiService: MockAuthAPIServiceProtocol) {
        self.apiService = apiService
    }

    func login(email: String, password: String) async throws -> User {
        do {
            let dto = try await apiService.login(request: LoginRequestDTO(email: email, password: password))
            return dto.toDomain()
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.unknown
        }
    }

    func signup(firstName: String, lastName: String, email: String, password: String) async throws -> User {
        do {
            let dto = try await apiService.signup(
                request: SignupRequestDTO(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password
                )
            )
            return dto.toDomain()
        } catch let error as AuthError {
            throw error
        } catch {
            throw AuthError.unknown
        }
    }
}
