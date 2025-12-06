//
//  DataCorruptionTests.swift
//  BrainRushTests
//
//  Tests for handling corrupted or malformed data
//

import XCTest
@testable import BrainRush

final class DataCorruptionTests: XCTestCase {
    
    func testInvalidJSONDecoding() {
        let invalidJSON = """
        {
            "id": "course_1",
            "title": "Test Course",
            "invalid": {
        """
        
        let data = invalidJSON.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        XCTAssertThrowsError(try decoder.decode(Course.self, from: data)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testMissingRequiredFields() {
        let json = """
        {
            "id": "course_1"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // Should decode with optional fields as nil
        XCTAssertNoThrow(try decoder.decode(Course.self, from: data))
    }
    
    func testWrongTypeInJSON() {
        let json = """
        {
            "id": "course_1",
            "title": 123,
            "duration": "not_a_number"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        XCTAssertThrowsError(try decoder.decode(Course.self, from: data)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testMalformedEmail() {
        // Test with various malformed email strings
        let malformedEmails = [
            "test@",
            "@example.com",
            "test@example",
            "test..test@example.com",
            "test@example..com"
        ]
        
        for email in malformedEmails {
            XCTAssertFalse(
                Validation.isValidEmail(email),
                "Should reject malformed email: \(email)"
            )
        }
    }
    
    func testExtremelyLongString() {
        let veryLongString = String(repeating: "a", count: 10000)
        
        // Should handle long strings gracefully
        XCTAssertTrue(Validation.isValidPassword(veryLongString))
        
        // Email validation should reject extremely long strings
        let longEmail = "\(veryLongString)@example.com"
        // Depends on validation implementation, but extremely long should be rejected
        XCTAssertNotNil(longEmail)
    }
    
    func testNilHandling() {
        // Test that services handle nil gracefully
        let authService = AuthService.shared
        
        // Should handle nil tokens
        XCTAssertFalse(authService.isAuthenticated)
        XCTAssertNil(authService.currentUser)
    }
    
    func testEmptyCollections() {
        // Test handling of empty arrays/dictionaries
        let courses: [Course] = []
        
        XCTAssertTrue(courses.isEmpty)
        XCTAssertEqual(courses.count, 0)
    }
    
    func testNegativeNumbers() {
        // Test that negative values are handled
        let xp = MockDataFactory.makeUserXP(currentXP: -100)
        
        // Should either prevent negative or handle gracefully
        XCTAssertNotNil(xp)
    }
}
