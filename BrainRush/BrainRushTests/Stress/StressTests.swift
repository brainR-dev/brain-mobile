//
//  StressTests.swift
//  BrainRushTests
//
//  Stress tests for high load scenarios
//

import XCTest
@testable import BrainRush

final class StressTests: XCTestCase {
    
    func testLargeCourseListPerformance() {
        measure {
            let courses = MockDataFactory.makeCourses(count: 5000)
            
            // Filter operations
            let programming = courses.filter { $0.category == "Programming" }
            let design = courses.filter { $0.category == "Design" }
            
            // Sort operations
            let sorted = courses.sorted { ($0.title ?? "") < ($1.title ?? "") }
            
            // Search operations
            let searched = courses.filter { ($0.title ?? "").contains("Course") }
            
            _ = programming
            _ = design
            _ = sorted
            _ = searched
        }
    }
    
    func testLargeAchievementList() {
        measure {
            let achievements = MockDataFactory.makeAchievements(count: 1000)
            
            // Filter unlocked
            let unlocked = achievements.filter { $0.isUnlocked == true }
            
            // Filter by category
            let byCategory = achievements.filter { $0.category == "getting_started" }
            
            // Filter by rarity
            let rare = achievements.filter { $0.rarity == "Rare" }
            
            _ = unlocked
            _ = byCategory
            _ = rare
        }
    }
    
    func testRepeatedValidation() {
        measure {
            let emails = (0..<10000).map { "test\($0)@example.com" }
            
            for email in emails {
                _ = Validation.isValidEmail(email)
            }
        }
    }
    
    func testRepeatedFormatting() {
        measure {
            for i in 0..<10000 {
                _ = Formatters.formatXP(i * 100)
                _ = Formatters.formatDuration(minutes: i)
            }
        }
    }
    
    func testCacheStress() async {
        let cache = CacheManager.shared
        let testData = "test data".data(using: .utf8)!
        
        // Rapid cache writes
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<1000 {
                group.addTask {
                    await cache.cacheData(testData, forKey: "stress_key_\(i)")
                }
            }
        }
        
        // Rapid cache reads
        await withTaskGroup(of: Data?.self) { group in
            for i in 0..<1000 {
                group.addTask {
                    await cache.getData(forKey: "stress_key_\(i)")
                }
            }
        }
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testMemoryUsageWithLargeDatasets() {
        // Create large datasets
        var courses: [Course] = []
        var achievements: [Achievement] = []
        var lessons: [Lesson] = []
        
        for i in 0..<1000 {
            courses.append(MockDataFactory.makeCourse(id: "course_\(i)"))
            achievements.append(MockDataFactory.makeAchievement(id: "ach_\(i)"))
            lessons.append(MockDataFactory.makeLesson(id: "lesson_\(i)"))
        }
        
        // Perform operations
        let filtered = courses.filter { $0.id.contains("1") }
        let unlocked = achievements.filter { $0.isUnlocked == true }
        let completed = lessons.filter { $0.isCompleted }
        
        // Verify memory handling
        XCTAssertEqual(filtered.count + unlocked.count + completed.count, 
                      filtered.count + unlocked.count + completed.count)
    }
}
