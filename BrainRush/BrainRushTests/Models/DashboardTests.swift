//
//  DashboardTests.swift
//  BrainRushTests
//
//  Unit tests for Dashboard models
//

import XCTest
@testable import BrainRush

final class DashboardTests: XCTestCase {
    
    func testDashboardDataDecoding() throws {
        let json = """
        {
            "continue_learning": {
                "course_id": "course_1",
                "course_title": "Test Course",
                "lesson_id": "lesson_1",
                "lesson_title": "Test Lesson",
                "progress": 0.6
            },
            "recommended_courses": [],
            "recent_activity": [],
            "quick_stats": {
                "courses_in_progress": 3,
                "courses_completed": 5,
                "current_xp": 750,
                "current_level": 12,
                "study_streak": 7
            },
            "upcoming_deadlines": []
        }
        """
        
        let data = try TestHelpers.decodeJSON(json, as: DashboardData.self)
        
        XCTAssertNotNil(data.continueLearning)
        XCTAssertEqual(data.continueLearning?.courseId, "course_1")
        XCTAssertEqual(data.quickStats.currentLevel, 12)
        XCTAssertEqual(data.quickStats.studyStreak, 7)
    }
    
    func testQuickStatsDecoding() throws {
        let json = """
        {
            "courses_in_progress": 3,
            "courses_completed": 5,
            "current_xp": 750,
            "current_level": 12,
            "study_streak": 7
        }
        """
        
        let stats = try TestHelpers.decodeJSON(json, as: QuickStats.self)
        
        XCTAssertEqual(stats.coursesInProgress, 3)
        XCTAssertEqual(stats.coursesCompleted, 5)
        XCTAssertEqual(stats.currentXP, 750)
        XCTAssertEqual(stats.currentLevel, 12)
        XCTAssertEqual(stats.studyStreak, 7)
    }
    
    func testContinueLearningDecoding() throws {
        let json = """
        {
            "course_id": "course_1",
            "course_title": "Test Course",
            "lesson_id": "lesson_1",
            "lesson_title": "Test Lesson",
            "progress": 0.6
        }
        """
        
        let continueLearning = try TestHelpers.decodeJSON(json, as: ContinueLearning.self)
        
        XCTAssertEqual(continueLearning.courseId, "course_1")
        XCTAssertEqual(continueLearning.lessonId, "lesson_1")
        XCTAssertEqual(continueLearning.progress, 0.6, accuracy: 0.01)
    }
    
    func testActivityItemDecoding() throws {
        let json = """
        {
            "id": "activity_1",
            "type": "lesson_completed",
            "title": "Completed lesson",
            "description": "You completed a lesson",
            "timestamp": "2024-01-01T00:00:00Z",
            "metadata": null
        }
        """
        
        let activity = try TestHelpers.decodeJSON(json, as: ActivityItem.self)
        
        XCTAssertEqual(activity.id, "activity_1")
        XCTAssertEqual(activity.type, "lesson_completed")
        XCTAssertEqual(activity.title, "Completed lesson")
    }
}
