//
//  ValidatePasswordUseCaseTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

final class ValidatePasswordUseCaseTests: XCTestCase {
    func test_WhenLoginPasswordEmpty_ThenReturnsEmpty() {
        let sut = ValidatePasswordUseCase(kind: .login)
        XCTAssertEqual(sut.execute(password: ""), .empty)
    }

    func test_WhenLoginPasswordNonEmpty_ThenReturnsNil() {
        let sut = ValidatePasswordUseCase(kind: .login)
        XCTAssertNil(sut.execute(password: "x"))
    }

    func test_WhenSignupPasswordMissingSpecial_ThenReturnsError() {
        let sut = ValidatePasswordUseCase(kind: .signup)
        XCTAssertEqual(sut.execute(password: "NoSpecial1"), .missingSpecialCharacter)
    }

    func test_WhenSignupPasswordValid_ThenReturnsNil() {
        let sut = ValidatePasswordUseCase(kind: .signup)
        XCTAssertNil(sut.execute(password: "GoodPass1!"))
    }
}
