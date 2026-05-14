//
//  SignupViewModel.swift
//  AuthenticateMe
//

import Combine
import Foundation

// MARK: - SignupViewModel

@MainActor
final class SignupViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published private(set) var firstNameError: String?
    @Published private(set) var lastNameError: String?
    @Published private(set) var emailError: String?
    @Published private(set) var passwordError: String?
    @Published private(set) var confirmPasswordError: String?
    @Published private(set) var isLoading: Bool = false
    @Published var bannerMessage: String?

    private let signupUseCase: SignupUseCase
    private let validateEmail: ValidateEmailUseCase
    private let validateSignupPassword: ValidatePasswordUseCase
    private let validateName: ValidateNameUseCase
    private let validateConfirmPassword: ValidateConfirmPasswordUseCase
    private let onAuthenticated: (User) -> Void
    private let onNavigateBackToLogin: () -> Void

    var isSubmitEnabled: Bool {
        firstNameError == nil && lastNameError == nil &&
            emailError == nil && passwordError == nil && confirmPasswordError == nil &&
            !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !password.isEmpty &&
            !confirmPassword.isEmpty &&
            !isLoading
    }

    init(
        signupUseCase: SignupUseCase,
        validateEmail: ValidateEmailUseCase,
        validateSignupPassword: ValidatePasswordUseCase,
        validateName: ValidateNameUseCase,
        validateConfirmPassword: ValidateConfirmPasswordUseCase,
        onAuthenticated: @escaping (User) -> Void,
        onNavigateBackToLogin: @escaping () -> Void
    ) {
        self.signupUseCase = signupUseCase
        self.validateEmail = validateEmail
        self.validateSignupPassword = validateSignupPassword
        self.validateName = validateName
        self.validateConfirmPassword = validateConfirmPassword
        self.onAuthenticated = onAuthenticated
        self.onNavigateBackToLogin = onNavigateBackToLogin
        revalidate()
    }

    func onFirstNameChanged(_ value: String) {
        firstName = value
        revalidate()
    }

    func onLastNameChanged(_ value: String) {
        lastName = value
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

    func onConfirmPasswordChanged(_ value: String) {
        confirmPassword = value
        revalidate()
    }

    func submit() async {
        guard isSubmitEnabled else { return }
        bannerMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let user = try await signupUseCase.execute(
                firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
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

    func navigateBackToLogin() {
        onNavigateBackToLogin()
    }

    private func revalidate() {
        firstNameError = LocalizedValidationMessage.message(for: validateName.execute(name: firstName))
        lastNameError = LocalizedValidationMessage.message(for: validateName.execute(name: lastName))
        emailError = LocalizedValidationMessage.message(for: validateEmail.execute(email: email))
        passwordError = LocalizedValidationMessage.message(for: validateSignupPassword.execute(password: password))
        confirmPasswordError = LocalizedValidationMessage.message(
            for: validateConfirmPassword.execute(password: password, confirmPassword: confirmPassword)
        )
    }
}
