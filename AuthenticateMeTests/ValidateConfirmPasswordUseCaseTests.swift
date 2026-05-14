//
//  ValidateConfirmPasswordUseCaseTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

final class ValidateConfirmPasswordUseCaseTests: XCTestCase {
    private let sut = ValidateConfirmPasswordUseCase()

    func test_WhenPasswordsMismatch_ThenReturnsMismatch() {
        XCTAssertEqual(sut.execute(password: "a", confirmPassword: "b"), .mismatch)
    }

    func test_WhenPasswordsMatch_ThenReturnsNil() {
        XCTAssertNil(sut.execute(password: "Same1!", confirmPassword: "Same1!"))
    }
}
