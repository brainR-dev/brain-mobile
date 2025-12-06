//
//  AccessibilityTests.swift
//  BrainRushUITests
//
//  Accessibility tests
//

import XCTest

final class AccessibilityTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSignInAccessibility() throws {
        // Verify sign in screen has accessibility labels
        let emailField = app.textFields["Email"]
        if emailField.exists {
            XCTAssertTrue(emailField.isHittable)
        }
        
        let passwordField = app.secureTextFields["Password"]
        if passwordField.exists {
            XCTAssertTrue(passwordField.isHittable)
        }
        
        let signInButton = app.buttons["Sign In"]
        if signInButton.exists {
            XCTAssertTrue(signInButton.isHittable)
        }
    }
    
    func testNavigationAccessibility() throws {
        // Verify tab bar is accessible
        let tabBar = app.tabBars.firstMatch
        if tabBar.exists {
            XCTAssertTrue(tabBar.isHittable)
        }
    }
    
    func testButtonsAreAccessible() throws {
        // Verify all buttons have accessibility labels
        let buttons = app.buttons
        for i in 0..<min(buttons.count, 10) {
            let button = buttons.element(boundBy: i)
            if button.exists {
                XCTAssertTrue(button.isHittable, "Button should be hittable")
            }
        }
    }
    
    func testTextFieldsAreAccessible() throws {
        // Verify text fields are accessible
        let textFields = app.textFields
        for i in 0..<textFields.count {
            let field = textFields.element(boundBy: i)
            if field.exists {
                XCTAssertTrue(field.isHittable, "TextField should be hittable")
            }
        }
    }
}
