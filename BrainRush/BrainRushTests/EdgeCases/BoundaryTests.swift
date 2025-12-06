//
//  BoundaryTests.swift
//  BrainRushTests
//
//  Boundary value testing
//

import XCTest
@testable import BrainRush

final class BoundaryTests: XCTestCase {
    
    func testPasswordMinLength() {
        // Exactly 8 characters (minimum)
        XCTAssertTrue(Validation.isValidPassword("12345678"))
        
        // 7 characters (below minimum)
        XCTAssertFalse(Validation.isValidPassword("1234567"))
        
        // 9 characters (above minimum)
        XCTAssertTrue(Validation.isValidPassword("123456789"))
    }
    
    func testXPBoundaries() {
        // Zero XP
        XCTAssertEqual(Formatters.formatXP(0), "0")
        
        // Very large XP
        XCTAssertNotNil(Formatters.formatXP(Int.max))
        
        // Negative XP (should handle gracefully)
        XCTAssertNotNil(Formatters.formatXP(-100))
    }
    
    func testDurationBoundaries() {
        // Zero minutes
        XCTAssertEqual(Formatters.formatDuration(minutes: 0), "0m")
        
        // Exactly 60 minutes (1 hour)
        XCTAssertEqual(Formatters.formatDuration(minutes: 60), "1h")
        
        // 59 minutes (just below 1 hour)
        XCTAssertEqual(Formatters.formatDuration(minutes: 59), "59m")
        
        // 61 minutes (just above 1 hour)
        XCTAssertEqual(Formatters.formatDuration(minutes: 61), "1h 1m")
        
        // Very large duration
        XCTAssertNotNil(Formatters.formatDuration(minutes: Int.max))
    }
    
    func testLevelBoundaries() {
        // Level 1 (minimum)
        let xp1 = MockDataFactory.makeUserXP(level: 1)
        XCTAssertEqual(xp1.level, 1)
        
        // Very high level
        let xpHigh = MockDataFactory.makeUserXP(level: 999)
        XCTAssertEqual(xpHigh.level, 999)
        
        // Zero level (edge case)
        let xpZero = MockDataFactory.makeUserXP(level: 0)
        XCTAssertEqual(xpZero.level, 0)
    }
    
    func testProgressBoundaries() {
        // 0% progress
        let lesson1 = MockDataFactory.makeLesson()
        XCTAssertNotNil(lesson1.progress)
        
        // 100% progress
        let lesson2 = MockDataFactory.makeLesson(isCompleted: true)
        XCTAssertEqual(lesson2.progress, 1.0, accuracy: 0.01)
        
        // Exactly 50% progress
        let course = MockDataFactory.makeCourse()
        // Progress would be set separately
        XCTAssertNotNil(course)
    }
    
    func testArrayBoundaries() {
        // Empty array
        let emptyCourses: [Course] = []
        XCTAssertTrue(emptyCourses.isEmpty)
        
        // Single item
        let singleCourse = [MockDataFactory.makeCourse()]
        XCTAssertEqual(singleCourse.count, 1)
        
        // Many items
        let manyCourses = MockDataFactory.makeCourses(count: 1000)
        XCTAssertEqual(manyCourses.count, 1000)
    }
    
    func testStringBoundaries() {
        // Empty string
        XCTAssertFalse(Validation.isValidEmail(""))
        XCTAssertFalse(Validation.isValidPassword(""))
        
        // Single character
        XCTAssertFalse(Validation.isValidEmail("a"))
        XCTAssertFalse(Validation.isValidPassword("a"))
        
        // Very long string
        let longString = String(repeating: "a", count: 10000)
        XCTAssertTrue(Validation.isValidPassword(longString))
    }
}
