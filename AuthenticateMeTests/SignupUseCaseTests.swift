//
//  SignupUseCaseTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

final class SignupUseCaseTests: XCTestCase {
    func test_WhenSignupSucceeds_ThenReturnsUser() async throws {
        let api = MockAuthAPIService(configuration: TestNetworkConfiguration.instantSuccess())
        let repository = AuthenticationRepository(apiService: api)
        let sut = SignupUseCase(repository: repository)

        let user = try await sut.execute(
            firstName: "Jane",
            lastName: "Doe",
            email: "new@example.com",
            password: "ValidPass1!"
        )

        XCTAssertEqual(user.firstName, "Jane")
        XCTAssertEqual(user.lastName, "Doe")
        XCTAssertEqual(user.email, "new@example.com")
    }

    func test_WhenEmailBlocked_ThenThrowsEmailAlreadyRegistered() async {
        let api = MockAuthAPIService(configuration: TestNetworkConfiguration.instantSuccess())
        let repository = AuthenticationRepository(apiService: api)
        let sut = SignupUseCase(repository: repository)

        do {
            _ = try await sut.execute(
                firstName: "Jane",
                lastName: "Doe",
                email: "taken@example.com",
                password: "ValidPass1!"
            )
            XCTFail("Expected error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .emailAlreadyRegistered)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
