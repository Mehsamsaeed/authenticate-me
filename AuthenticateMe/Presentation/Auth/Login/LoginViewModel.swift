//
//  LoginViewModel.swift
//  AuthenticateMe
//

import Combine
import Foundation

// MARK: - LoginViewModel

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""

    @Published private(set) var emailError: String?
    @Published private(set) var passwordError: String?
    @Published private(set) var isLoading: Bool = false
    @Published var bannerMessage: String?
    @Published var isForgotPasswordAlertPresented: Bool = false

    private let loginUseCase: LoginUseCase
    private let validateEmail: ValidateEmailUseCase
    private let validatePassword: ValidatePasswordUseCase
    private let onAuthenticated: (User) -> Void
    private let onNavigateToSignup: () -> Void

    var isSubmitEnabled: Bool {
        emailError == nil && passwordError == nil &&
            !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !isLoading
    }

    init(
        loginUseCase: LoginUseCase,
        validateEmail: ValidateEmailUseCase,
        validatePassword: ValidatePasswordUseCase,
        onAuthenticated: @escaping (User) -> Void,
        onNavigateToSignup: @escaping () -> Void
    ) {
        self.loginUseCase = loginUseCase
        self.validateEmail = validateEmail
        self.validatePassword = validatePassword
        self.onAuthenticated = onAuthenticated
        self.onNavigateToSignup = onNavigateToSignup
        revalidate()
    }

    func onEmailChanged(_ value: String) {
        email = value
        revalidate()
    }

    func onPasswordChanged(_ value: String) {
        password = value
        revalidate()
    }

    func submit() async {
        guard isSubmitEnabled else { return }
        bannerMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let user = try await loginUseCase.execute(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            onAuthenticated(user)
        } catch let error as AuthError {
            bannerMessage = LocalizedValidationMessage.message(for: error)
        } catch {
            bannerMessage = LocalizedValidationMessage.message(for: .unknown)
        }
    }

    func navigateToSignup() {
        onNavigateToSignup()
    }

    func presentForgotPassword() {
        isForgotPasswordAlertPresented = true
    }

    private func revalidate() {
        emailError = LocalizedValidationMessage.message(for: validateEmail.execute(email: email))
        passwordError = LocalizedValidationMessage.message(for: validatePassword.execute(password: password))
    }
}
