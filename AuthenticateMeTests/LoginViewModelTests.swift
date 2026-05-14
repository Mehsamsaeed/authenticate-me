//
//  LoginViewModelTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

// MARK: - LoginViewModelTests

@MainActor
final class LoginViewModelTests: XCTestCase {
    func test_WhenEmailIsEmpty_ThenSubmitIsDisabled() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        XCTAssertFalse(viewModel.isSubmitEnabled)
    }

    func test_WhenEmailInvalid_ThenSubmitIsDisabled() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        viewModel.onEmailChanged("not-an-email")
        viewModel.onPasswordChanged("secret")
        XCTAssertFalse(viewModel.isSubmitEnabled)
        XCTAssertNotNil(viewModel.emailError)
    }

    func test_WhenPasswordEmpty_ThenSubmitIsDisabled() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        viewModel.onEmailChanged("user@example.com")
        XCTAssertFalse(viewModel.isSubmitEnabled)
        XCTAssertNotNil(viewModel.passwordError)
    }

    func test_WhenCredentialsValid_ThenSubmitIsEnabled() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        viewModel.onEmailChanged("user@example.com")
        viewModel.onPasswordChanged("secret")
        XCTAssertTrue(viewModel.isSubmitEnabled)
    }

    func test_WhenLoginSucceeds_ThenInvokesAuthenticated() async {
        var receivedUser: User?
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess()) { user in
            receivedUser = user
        }

        viewModel.onEmailChanged("user@example.com")
        viewModel.onPasswordChanged("secret")

        await viewModel.submit()

        XCTAssertNotNil(receivedUser)
        XCTAssertEqual(receivedUser?.email, "user@example.com")
        XCTAssertNil(viewModel.bannerMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_WhenLoginFails_ThenBannerShowsMessage() async {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantLoginFailure(), onAuthenticated: { _ in })

        viewModel.onEmailChanged("user@example.com")
        viewModel.onPasswordChanged("secret")

        await viewModel.submit()

        XCTAssertNotNil(viewModel.bannerMessage)
    }

    private func makeViewModel(
        configuration: NetworkSimulationConfiguration,
        onAuthenticated: @escaping (User) -> Void = { _ in }
    ) -> LoginViewModel {
        let api = MockAuthAPIService(configuration: configuration)
        let repository = AuthenticationRepository(apiService: api)
        let loginUseCase = LoginUseCase(repository: repository)
        return LoginViewModel(
            loginUseCase: loginUseCase,
            validateEmail: ValidateEmailUseCase(),
            validatePassword: ValidatePasswordUseCase(kind: .login),
            onAuthenticated: onAuthenticated,
            onNavigateToSignup: {}
        )
    }
}
