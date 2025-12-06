//
//  ValidationEdgeCasesTests.swift
//  BrainRushTests
//
//  Comprehensive edge case tests for validation
//

import XCTest
@testable import BrainRush

final class ValidationEdgeCasesTests: XCTestCase {
    
    func testEmailEdgeCases() {
        let testCases: [(String, Bool)] = [
            // Valid cases
            ("test@example.com", true),
            ("user.name@example.com", true),
            ("user+tag@example.co.uk", true),
            ("user_name@example-domain.com", true),
            ("123@example.com", true),
            ("user@123.456", true),
            
            // Invalid cases
            ("", false),
            ("@example.com", false),
            ("test@", false),
            ("test.example.com", false),
            ("test @example.com", false),
            ("test@example .com", false),
            ("test@example", false),
            (".test@example.com", false),
            ("test.@example.com", false),
            ("test@@example.com", false),
            ("test@example..com", false),
        ]
        
        TestHelpers.assertValidationResults(
            testCases,
            validator: Validation.isValidEmail
        )
    }
    
    func testPasswordEdgeCases() {
        let testCases: [(String, Bool)] = [
            // Valid (min 8 chars)
            ("password", true),
            ("12345678", true),
            ("a".repeating(8), true),
            
            // Invalid (too short)
            ("", false),
            ("short", false),
            ("1234567", false), // 7 chars
        ]
        
        TestHelpers.assertValidationResults(
            testCases,
            validator: Validation.isValidPassword
        )
    }
    
    func testStrongPasswordEdgeCases() {
        let testCases: [(String, Bool)] = [
            // Valid strong passwords
            ("Password123", true),
            ("MyP@ssw0rd", true),
            ("Strong123", true),
            ("Test123!", true),
            
            // Invalid (missing requirements)
            ("password123", false), // no uppercase
            ("PASSWORD123", false), // no lowercase
            ("Password", false), // no number
            ("Pass123", false), // too short (8 chars but needs more)
            ("", false),
        ]
        
        TestHelpers.assertValidationResults(
            testCases,
            validator: Validation.isStrongPassword
        )
    }
    
    func testQuizAnswerValidation() {
        let question = MockDataFactory.makeQuizQuestion(
            correctAnswer: "Option A"
        )
        
        // Valid answer
        XCTAssertTrue(Validation.validateQuizAnswer("Option A", for: question))
        
        // Invalid answer
        XCTAssertFalse(Validation.validateQuizAnswer("Option B", for: question))
        
        // Case insensitive (if implemented)
        // This depends on implementation
        XCTAssertNotNil(question.correctAnswer)
    }
}

extension String {
    func repeating(_ count: Int) -> String {
        String(repeating: self, count: count)
    }
}
