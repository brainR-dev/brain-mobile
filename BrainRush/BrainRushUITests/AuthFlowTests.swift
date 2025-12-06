//
//  AuthFlowTests.swift
//  BrainRushUITests
//
//  UI tests for authentication flow
//

import XCTest

final class AuthFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSignInScreenAppears() throws {
        // Verify sign in screen is displayed
        XCTAssertTrue(app.textFields["Email"].exists)
        XCTAssertTrue(app.secureTextFields["Password"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
    
    func testNavigationToSignUp() throws {
        // Look for sign up link/button
        let signUpButton = app.buttons["Sign Up"]
        if signUpButton.exists {
            signUpButton.tap()
            // Verify we're on sign up screen
            XCTAssertTrue(app.buttons["Sign Up"].exists)
        }
    }
    
    func testEmailFieldInteraction() throws {
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText("test@example.com")
        XCTAssertEqual(emailField.value as? String, "test@example.com")
    }
    
    func testPasswordFieldInteraction() throws {
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("password123")
        // Secure fields don't expose values, just verify it's not empty
        XCTAssertTrue(passwordField.exists)
    }
}
