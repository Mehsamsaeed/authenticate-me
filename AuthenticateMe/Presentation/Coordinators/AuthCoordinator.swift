//
//  AuthCoordinator.swift
//  AuthenticateMe
//

import Combine
import Foundation

// MARK: - AuthCoordinator

/// Coordinates navigation between login and signup while delegating successful auth to the app coordinator.
@MainActor
final class AuthCoordinator: ObservableObject {
    /// Drives the signup destination in `AuthCoordinatorView`.
    @Published var isSignupPresented = false

    private let dependencies: AppDependencies
    private let onAuthenticated: (User) -> Void

    private let loginFlowRelay: AuthLoginFlowRelay

    /// Set only from `showSignup`; read by `AuthCoordinatorView` for a stable `SignupView` instance.
    @Published private(set) var signupViewModel: SignupViewModel?

    /// Created in `init` so the login screen never reads a lazily materialized model mid-update.
    let loginViewModel: LoginViewModel

    init(dependencies: AppDependencies, onAuthenticated: @escaping (User) -> Void) {
        self.dependencies = dependencies
        self.onAuthenticated = onAuthenticated
        self.isSignupPresented = false

        let relay = AuthLoginFlowRelay()
        self.loginFlowRelay = relay
        self.signupViewModel = nil

        self.loginViewModel = LoginViewModel(
            loginUseCase: dependencies.loginUseCase,
            validateEmail: dependencies.validateEmail,
            validatePassword: dependencies.validateLoginPassword,
            onAuthenticated: { user in
                relay.forwardLoginSuccess(user)
            },
            onNavigateToSignup: {
                relay.forwardNavigateToSignup()
            }
        )
        relay.coordinator = self
    }

    func showSignup() {
        signupViewModel = makeSignupViewModel()
        isSignupPresented = true
    }

    func dismissSignup() {
        isSignupPresented = false
        signupViewModel = nil
    }

    func completeAuthentication(with user: User) {
        isSignupPresented = false
        signupViewModel = nil
        onAuthenticated(user)
    }

    func makeSignupViewModel() -> SignupViewModel {
        SignupViewModel(
            signupUseCase: dependencies.signupUseCase,
            validateEmail: dependencies.validateEmail,
            validateSignupPassword: dependencies.validateSignupPassword,
            validateName: dependencies.validateName,
            validateConfirmPassword: dependencies.validateConfirmPassword,
            onAuthenticated: { [weak self] user in
                self?.completeAuthentication(with: user)
            },
            onNavigateBackToLogin: { [weak self] in
                self?.dismissSignup()
            }
        )
    }
}

// MARK: - AuthLoginFlowRelay

/// Avoids capturing `AuthCoordinator` before `loginViewModel` finishes initializing.
@MainActor
private final class AuthLoginFlowRelay {
    weak var coordinator: AuthCoordinator?

    func forwardLoginSuccess(_ user: User) {
        coordinator?.completeAuthentication(with: user)
    }

    func forwardNavigateToSignup() {
        coordinator?.showSignup()
    }
}
