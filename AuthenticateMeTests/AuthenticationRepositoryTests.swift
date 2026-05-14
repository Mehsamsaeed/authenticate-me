//
//  AuthenticationRepositoryTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

final class AuthenticationRepositoryTests: XCTestCase {
    func test_WhenNetworkFails_ThenThrowsNetworkUnavailable() async {
        let api = MockAuthAPIService(configuration: TestNetworkConfiguration.instantNetworkFailure())
        let sut = AuthenticationRepository(apiService: api)

        do {
            _ = try await sut.login(email: "user@example.com", password: "secret")
            XCTFail("Expected error")
        } catch let error as AuthError {
            XCTAssertEqual(error, .networkUnavailable)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}
