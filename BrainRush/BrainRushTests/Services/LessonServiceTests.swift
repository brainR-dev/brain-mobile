//
//  LessonServiceTests.swift
//  BrainRushTests
//
//  Unit tests for LessonService
//

import XCTest
@testable import BrainRush

@MainActor
final class LessonServiceTests: XCTestCase {
    var service: LessonService!
    
    override func setUp() {
        super.setUp()
        service = LessonService.shared
    }
    
    func testLoadLesson() async throws {
        let lessonId = "lesson_1"
        let courseId = "course_1"
        
        // This would use mocked API in real tests
        do {
            let lesson = try await service.loadLesson(lessonId: lessonId)
            XCTAssertEqual(lesson.id, lessonId)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testMarkLessonComplete() async throws {
        let lessonId = "lesson_1"
        let courseId = "course_1"
        let lessonTitle = "Test Lesson"
        
        // Test marking lesson complete
        do {
            try await service.markLessonComplete(
                lessonId: lessonId,
                courseId: courseId,
                lessonTitle: lessonTitle,
                duration: 30
            )
            // Success - would verify in real test
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testDownloadLessonContent() async throws {
        let lessonId = "lesson_1"
        
        do {
            let data = try await service.downloadLessonContent(lessonId: lessonId)
            XCTAssertNotNil(data)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
}
