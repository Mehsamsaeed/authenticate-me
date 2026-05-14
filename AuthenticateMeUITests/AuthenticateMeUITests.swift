//
//  AuthenticateMeUITests.swift
//  AuthenticateMeUITests
//
//  UI tests exercise accessibility identifiers defined in `AccessibilityID`.
//  Launch env keys mirror `UITestEnvironmentKey` in the app target (see `MockAuthAPIService` / `SecureAppTextField`).
//

import XCTest

// MARK: - AuthenticateMeUITests

final class AuthenticateMeUITests: XCTestCase {
    private var app: XCUIApplication!

    /// Must match `UITestEnvironmentKey.plainTextPasswordFields` in the app — `SecureField` + XCTest drops characters.
    private let plainTextPasswordsKey = "UITEST_PLAIN_TEXT_PASSWORDS"

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["UITEST_FAST_DELAY"] = "1"
        app.launchEnvironment[plainTextPasswordsKey] = "1"
    }

    func test_WhenLoginCredentialsValid_ThenNavigatesToHome() throws {
        app.launch()

        try fillLogin(email: "user@example.com", password: "secret")
        app.buttons["login.submit.button"].tap()

        XCTAssertTrue(app.staticTexts["home.title"].waitForExistence(timeout: 6))
    }

    func test_WhenLoginFormInvalid_ThenSubmitStaysDisabled() throws {
        app.launch()

        XCTAssertFalse(app.buttons["login.submit.button"].isEnabled)

        typeText(into: app.textFields["login.email.field"], "not-an-email")
        typeText(into: passwordField("login.password.field"), "secret")

        XCTAssertFalse(app.buttons["login.submit.button"].isEnabled)
        XCTAssertTrue(app.staticTexts["login.email.field.error"].waitForExistence(timeout: 2))
    }

    func test_WhenSignupFormValid_ThenNavigatesToHome() throws {
        app.launch()

        tapGoToSignupFromLogin()

        XCTAssertTrue(app.textFields["signup.firstName.field"].waitForExistence(timeout: 5))

        typeText(into: app.textFields["signup.firstName.field"], "Jane")
        typeText(into: app.textFields["signup.lastName.field"], "Doe")
        typeText(into: app.textFields["signup.email.field"], "newuser@example.com")

        scrollSignupFormUpIfNeeded()

        let password = "ValidPass1!"
        typeText(into: passwordField("signup.password.field"), password)
        typeText(into: passwordField("signup.confirmPassword.field"), password)

        dismissKeyboardByTappingNavigationBar()

        let submit = app.buttons["signup.submit.button"]
        XCTAssertTrue(
            waitForElementToBecomeEnabled(submit, timeout: 20),
            signupSubmitDisabledDebugMessage()
        )
        submit.tap()

        XCTAssertTrue(app.staticTexts["home.title"].waitForExistence(timeout: 12))
    }

    func test_WhenSignupPasswordWeak_ThenSubmitStaysDisabled() throws {
        app.launch()

        tapGoToSignupFromLogin()
        XCTAssertTrue(app.textFields["signup.firstName.field"].waitForExistence(timeout: 3))

        typeText(into: app.textFields["signup.firstName.field"], "Jane")
        typeText(into: app.textFields["signup.lastName.field"], "Doe")
        typeText(into: app.textFields["signup.email.field"], "newuser@example.com")

        typeText(into: passwordField("signup.password.field"), "weak")
        typeText(into: passwordField("signup.confirmPassword.field"), "weak")

        XCTAssertFalse(app.buttons["signup.submit.button"].isEnabled)
        XCTAssertTrue(app.staticTexts["signup.password.field.error"].waitForExistence(timeout: 2))
    }

    func test_WhenNavigatingBetweenLoginAndSignup_ThenScreensToggle() throws {
        app.launch()

        XCTAssertTrue(app.textFields["login.email.field"].waitForExistence(timeout: 3))
        tapGoToSignupFromLogin()

        XCTAssertTrue(app.textFields["signup.firstName.field"].waitForExistence(timeout: 3))

        app.buttons["signup.backToLogin.link"].tap()
        XCTAssertTrue(app.textFields["login.email.field"].waitForExistence(timeout: 3))
    }

    /// Password fields are plain `TextField`s when `plainTextPasswordsKey` is set at launch (see `SecureAppTextField`).
    private func passwordField(_ accessibilityIdentifier: String) -> XCUIElement {
        app.textFields[accessibilityIdentifier]
    }

    private func typeText(into field: XCUIElement, _ text: String) {
        XCTAssertTrue(field.waitForExistence(timeout: 3), "Missing field for typing")

        // Moving focus between TextFields often requires ending the previous field’s first responder;
        // otherwise `typeText` fails with "Neither element nor any descendant has keyboard focus".
        if app.keyboards.element(boundBy: 0).exists {
            dismissKeyboardByTappingNavigationBar()
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.25))
        }

        field.tap()
        if !waitForKeyboardFocus(on: field, timeout: 2) {
            field.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
            _ = waitForKeyboardFocus(on: field, timeout: 2)
        }

        field.typeText(text)
    }

    @discardableResult
    private func waitForKeyboardFocus(on field: XCUIElement, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "hasKeyboardFocus == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: field)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }

    private func scrollSignupFormUpIfNeeded() {
        let scroll = app.scrollViews.firstMatch
        guard scroll.waitForExistence(timeout: 2) else { return }
        scroll.swipeUp()
        scroll.swipeUp()
    }

    private func dismissKeyboardByTappingNavigationBar() {
        let nav = app.navigationBars.firstMatch
        guard nav.waitForExistence(timeout: 2) else { return }
        nav.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
    }

    @discardableResult
    private func waitForElementToBecomeEnabled(_ element: XCUIElement, timeout: TimeInterval) -> Bool {
        let predicate = NSPredicate(format: "isEnabled == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }

    private func signupSubmitDisabledDebugMessage() -> String {
        var parts: [String] = ["Signup submit stayed disabled."]
        let ids = [
            "signup.firstName.field.error",
            "signup.lastName.field.error",
            "signup.email.field.error",
            "signup.password.field.error",
            "signup.confirmPassword.field.error",
        ]
        for id in ids {
            let el = app.staticTexts[id]
            if el.exists {
                parts.append("\(id): \(el.label)")
            }
        }
        return parts.joined(separator: " ")
    }

    private func tapGoToSignupFromLogin() {
        let byButton = app.buttons["login.goToSignup.link"]
        let byLink = app.links["login.goToSignup.link"]
        if byButton.waitForExistence(timeout: 2) {
            byButton.tap()
            return
        }
        app.swipeUp()
        if byButton.waitForExistence(timeout: 2) {
            byButton.tap()
            return
        }
        XCTAssertTrue(byLink.waitForExistence(timeout: 2), "Expected login.goToSignup.link as button or link")
        byLink.tap()
    }

    private func fillLogin(email: String, password: String) throws {
        typeText(into: app.textFields["login.email.field"], email)
        typeText(into: passwordField("login.password.field"), password)
    }
}
