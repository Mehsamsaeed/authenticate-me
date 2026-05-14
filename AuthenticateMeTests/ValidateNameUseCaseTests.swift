//
//  ValidateNameUseCaseTests.swift
//  AuthenticateMeTests
//

import XCTest
@testable import AuthenticateMe

final class ValidateNameUseCaseTests: XCTestCase {
    private let sut = ValidateNameUseCase()

    func test_WhenNameWhitespaceOnly_ThenReturnsEmpty() {
        XCTAssertEqual(sut.execute(name: "   "), .empty)
    }

    func test_WhenNameProvided_ThenReturnsNil() {
        XCTAssertNil(sut.execute(name: "Jane"))
    }
}
