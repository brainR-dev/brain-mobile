//
//  PerformanceTests.swift
//  BrainRushTests
//
//  Performance tests
//

import XCTest
@testable import BrainRush

final class PerformanceTests: XCTestCase {
    
    func testCourseListPerformance() {
        measure {
            let courses = MockDataFactory.makeCourses(count: 1000)
            let filtered = courses.filter { $0.category == "Programming" }
            _ = filtered
        }
    }
    
    func testAchievementFilteringPerformance() {
        measure {
            let achievements = MockDataFactory.makeAchievements(count: 500, unlockedCount: 250)
            let unlocked = achievements.filter { $0.isUnlocked == true }
            _ = unlocked
        }
    }
    
    func testJSONDecodingPerformance() {
        let json = TestFixtures.sampleCourseJSON
        
        measure {
            for _ in 0..<100 {
                _ = try? TestHelpers.decodeJSON(json, as: Course.self)
            }
        }
    }
    
    func testValidationPerformance() {
        let emails = (0..<1000).map { "test\($0)@example.com" }
        
        measure {
            for email in emails {
                _ = Validation.isValidEmail(email)
            }
        }
    }
    
    func testFormattingPerformance() {
        measure {
            for i in 0..<10000 {
                _ = Formatters.formatXP(i * 100)
                _ = Formatters.formatDuration(minutes: i)
            }
        }
    }
}
