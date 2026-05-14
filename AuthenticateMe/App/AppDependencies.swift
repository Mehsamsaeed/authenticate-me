//
//  AppDependencies.swift
//  AuthenticateMe
//

import Foundation

// MARK: - AppDependencies

/// Application-wide dependencies assembled for protocol-oriented dependency injection.
struct AppDependencies: Sendable {
    let loginUseCase: LoginUseCase
    let signupUseCase: SignupUseCase
    let validateEmail: ValidateEmailUseCase
    let validateLoginPassword: ValidatePasswordUseCase
    let validateSignupPassword: ValidatePasswordUseCase
    let validateName: ValidateNameUseCase
    let validateConfirmPassword: ValidateConfirmPasswordUseCase

    static func live(apiService: MockAuthAPIServiceProtocol = MockAuthAPIService()) -> AppDependencies {
        let repository = AuthenticationRepository(apiService: apiService)
        return AppDependencies(
            loginUseCase: LoginUseCase(repository: repository),
            signupUseCase: SignupUseCase(repository: repository),
            validateEmail: ValidateEmailUseCase(),
            validateLoginPassword: ValidatePasswordUseCase(kind: .login),
            validateSignupPassword: ValidatePasswordUseCase(kind: .signup),
            validateName: ValidateNameUseCase(),
            validateConfirmPassword: ValidateConfirmPasswordUseCase()
        )
    }
}
