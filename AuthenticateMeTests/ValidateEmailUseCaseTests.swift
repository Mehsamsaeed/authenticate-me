//
//  ValidateEmailUseCaseTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

final class ValidateEmailUseCaseTests: XCTestCase {
    private let sut = ValidateEmailUseCase()

    func test_WhenEmailEmpty_ThenReturnsEmptyError() {
        XCTAssertEqual(sut.execute(email: ""), .empty)
    }

    func test_WhenEmailInvalid_ThenReturnsInvalidFormat() {
        XCTAssertEqual(sut.execute(email: "bad"), .invalidFormat)
    }

    func test_WhenEmailValid_ThenReturnsNil() {
        XCTAssertNil(sut.execute(email: "user.name+tag@example.co"))
    }
}
