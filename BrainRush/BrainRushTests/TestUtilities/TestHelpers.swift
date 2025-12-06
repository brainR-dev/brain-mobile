//
//  TestHelpers.swift
//  BrainRushTests
//
//  General test helpers and utilities
//

import Foundation
import XCTest
@testable import BrainRush

enum TestError: Error {
    case mockError
    case networkError
    case decodingError
}

struct TestHelpers {
    
    // MARK: - JSON Helpers
    
    static func jsonFromFile(_ filename: String) -> Data? {
        guard let path = Bundle(for: CourseTests.self).path(forResource: filename, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        return data
    }
    
    static func decodeJSON<T: Decodable>(_ json: String, as type: T.Type) throws -> T {
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: data)
    }
    
    // MARK: - Date Helpers
    
    static func makeDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // MARK: - Validation Helpers
    
    static func assertValidationResults<T>(
        _ testCases: [(input: T, expected: Bool)],
        validator: (T) -> Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        for testCase in testCases {
            let result = validator(testCase.input)
            XCTAssertEqual(
                result,
                testCase.expected,
                "Failed for input: \(testCase.input)",
                file: file,
                line: line
            )
        }
    }
    
    // MARK: - Async Helpers
    
    static func waitForCondition(
        timeout: TimeInterval = 2.0,
        condition: @escaping () -> Bool
    ) -> Bool {
        let expectation = XCTestExpectation(description: "Wait for condition")
        let startTime = Date()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if condition() || Date().timeIntervalSince(startTime) > timeout {
                timer.invalidate()
                expectation.fulfill()
            }
        }
        
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        return condition()
    }
    
    // MARK: - Mock Data Helpers
    
    static func createTestUser() -> UserProfile {
        MockDataFactory.makeUserProfile()
    }
    
    static func createTestCourse() -> Course {
        MockDataFactory.makeCourse()
    }
    
    static func createTestCourses(count: Int) -> [Course] {
        MockDataFactory.makeCourses(count: count)
    }
    
    // MARK: - Error Helpers
    
    static func assertAPIError(
        _ error: Error?,
        expectedType: APIError,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard let error = error as? APIError else {
            XCTFail("Expected APIError, got \(type(of: error))", file: file, line: line)
            return
        }
        
        switch (error, expectedType) {
        case (.unauthorized, .unauthorized),
             (.invalidURL, .invalidURL),
             (.noData, .noData):
            // Match
            break
        case (.serverError(let code1, _), .serverError(let code2, _)):
            XCTAssertEqual(code1, code2, file: file, line: line)
        default:
            XCTFail("Error type mismatch", file: file, line: line)
        }
    }
}

// MARK: - Test Fixtures

struct TestFixtures {
    static let validEmail = "test@example.com"
    static let invalidEmail = "invalid-email"
    static let validPassword = "Password123"
    static let weakPassword = "password"
    
    static let sampleCourseJSON = """
    {
        "id": "course_1",
        "title": "Test Course",
        "description": "Test description",
        "instructor": "Test Instructor",
        "duration": 120,
        "rating": 4.5
    }
    """
    
    static let sampleXPJSON = """
    {
        "current_xp": 750,
        "level": 12,
        "xp_to_next_level": 250,
        "lifetime_xp": 5000
    }
    """
}
