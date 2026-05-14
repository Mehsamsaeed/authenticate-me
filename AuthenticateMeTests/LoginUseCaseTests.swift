//
//  LoginUseCaseTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

final class LoginUseCaseTests: XCTestCase {
    func test_WhenLoginSucceeds_ThenReturnsUser() async throws {
        let api = MockAuthAPIService(configuration: TestNetworkConfiguration.instantSuccess())
        let repository = AuthenticationRepository(apiService: api)
        let sut = LoginUseCase(repository: repository)

        let user = try await sut.execute(email: "user@example.com", password: "secret")

        XCTAssertEqual(user.email, "user@example.com")
    }

    func test_WhenLoginFails_ThenThrowsAuthError() async {
        let api = MockAuthAPIService(configuration: TestNetworkConfiguration.instantLoginFailure())
        let repository = AuthenticationRepository(apiService: api)
        let sut = LoginUseCase(repository: repository)

        do {
            _ = try await sut.execute(email: "user@example.com", password: "secret")
            XCTFail("Expected error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .invalidCredentials)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
