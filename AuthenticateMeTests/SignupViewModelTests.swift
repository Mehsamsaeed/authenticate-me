//
//  SignupViewModelTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

// MARK: - SignupViewModelTests

@MainActor
final class SignupViewModelTests: XCTestCase {
    func test_WhenNamesMissing_ThenSubmitIsDisabled() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        XCTAssertFalse(viewModel.isSubmitEnabled)
    }

    func test_WhenPasswordWeak_ThenSubmitIsDisabled() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        viewModel.onFirstNameChanged("Jane")
        viewModel.onLastNameChanged("Doe")
        viewModel.onEmailChanged("jane@example.com")
        viewModel.onPasswordChanged("short")
        viewModel.onConfirmPasswordChanged("short")
        XCTAssertFalse(viewModel.isSubmitEnabled)
        XCTAssertNotNil(viewModel.passwordError)
    }

    func test_WhenPasswordsMismatch_ThenShowsConfirmError() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        viewModel.onFirstNameChanged("Jane")
        viewModel.onLastNameChanged("Doe")
        viewModel.onEmailChanged("jane@example.com")
        viewModel.onPasswordChanged("ValidPass1!")
        viewModel.onConfirmPasswordChanged("ValidPass1?")
        XCTAssertFalse(viewModel.isSubmitEnabled)
        XCTAssertNotNil(viewModel.confirmPasswordError)
    }

    func test_WhenFormValid_ThenSubmitIsEnabled() {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess())
        fillValidForm(viewModel)
        XCTAssertTrue(viewModel.isSubmitEnabled)
    }

    func test_WhenSignupSucceeds_ThenInvokesAuthenticated() async {
        var receivedUser: User?
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSuccess()) { user in
            receivedUser = user
        }
        fillValidForm(viewModel)

        await viewModel.submit()

        XCTAssertEqual(receivedUser?.firstName, "Jane")
        XCTAssertEqual(receivedUser?.lastName, "Doe")
        XCTAssertEqual(receivedUser?.email, "jane@example.com")
        XCTAssertNil(viewModel.bannerMessage)
    }

    func test_WhenSignupFails_ThenBannerShowsMessage() async {
        let viewModel = makeViewModel(configuration: TestNetworkConfiguration.instantSignupFailure(), onAuthenticated: { _ in })
        fillValidForm(viewModel)

        await viewModel.submit()

        XCTAssertNotNil(viewModel.bannerMessage)
    }

    private func fillValidForm(_ viewModel: SignupViewModel) {
        viewModel.onFirstNameChanged("Jane")
        viewModel.onLastNameChanged("Doe")
        viewModel.onEmailChanged("jane@example.com")
        viewModel.onPasswordChanged("ValidPass1!")
        viewModel.onConfirmPasswordChanged("ValidPass1!")
    }

    private func makeViewModel(
        configuration: NetworkSimulationConfiguration,
        onAuthenticated: @escaping (User) -> Void = { _ in }
    ) -> SignupViewModel {
        let api = MockAuthAPIService(configuration: configuration)
        let repository = AuthenticationRepository(apiService: api)
        let signupUseCase = SignupUseCase(repository: repository)
        return SignupViewModel(
            signupUseCase: signupUseCase,
            validateEmail: ValidateEmailUseCase(),
            validateSignupPassword: ValidatePasswordUseCase(kind: .signup),
            validateName: ValidateNameUseCase(),
            validateConfirmPassword: ValidateConfirmPasswordUseCase(),
            onAuthenticated: onAuthenticated,
            onNavigateBackToLogin: {}
        )
    }
}
