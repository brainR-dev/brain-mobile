//
//  ValidationTests.swift
//  BrainRushTests
//
//  Unit tests for Validation utilities
//

import XCTest
@testable import BrainRush

final class ValidationTests: XCTestCase {
    
    func testEmailValidation() {
        XCTAssertTrue(Validation.isValidEmail("test@example.com"))
        XCTAssertTrue(Validation.isValidEmail("user.name@domain.co.uk"))
        XCTAssertFalse(Validation.isValidEmail("invalid-email"))
        XCTAssertFalse(Validation.isValidEmail("test@"))
        XCTAssertFalse(Validation.isValidEmail("@example.com"))
        XCTAssertFalse(Validation.isValidEmail(""))
    }
    
    func testPasswordValidation() {
        XCTAssertTrue(Validation.isValidPassword("password123"))
        XCTAssertTrue(Validation.isValidPassword("12345678"))
        XCTAssertFalse(Validation.isValidPassword("short"))
        XCTAssertFalse(Validation.isValidPassword(""))
    }
    
    func testStrongPasswordValidation() {
        XCTAssertTrue(Validation.isStrongPassword("Password123"))
        XCTAssertTrue(Validation.isStrongPassword("MyP@ssw0rd"))
        XCTAssertFalse(Validation.isStrongPassword("password123")) // no uppercase
        XCTAssertFalse(Validation.isStrongPassword("PASSWORD123")) // no lowercase
        XCTAssertFalse(Validation.isStrongPassword("Password")) // no number
        XCTAssertFalse(Validation.isStrongPassword("Pass123")) // too short
    }
    
    func testStringExtensions() {
        XCTAssertTrue("test@example.com".isValidEmail)
        XCTAssertFalse("invalid".isValidEmail)
        
        XCTAssertTrue("password123".isValidPassword)
        XCTAssertFalse("short".isValidPassword)
        
        XCTAssertTrue("StrongPass123".isStrongPassword)
        XCTAssertFalse("weakpass".isStrongPassword)
    }
}
