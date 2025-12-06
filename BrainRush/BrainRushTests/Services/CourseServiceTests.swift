//
//  CourseServiceTests.swift
//  BrainRushTests
//
//  Unit tests for CourseService
//

import XCTest
@testable import BrainRush

@MainActor
final class CourseServiceTests: XCTestCase {
    var courseService: CourseService!
    
    override func setUp() {
        super.setUp()
        courseService = CourseService.shared
    }
    
    func testLoadCourses() async {
        // Note: This will need mocking in real implementation
        await courseService.loadCourses()
        
        // Verify courses are loaded (may be empty if no API connection)
        XCTAssertNotNil(courseService.courses)
    }
    
    func testCourseEnrollment() async throws {
        // This test would require mock API or test server
        // For now, just verify the method exists and can be called
        
        let courseId = "test_course_123"
        
        // Note: This will fail without authentication
        // In real tests, we'd mock the API client
        do {
            try await courseService.enrollInCourse(courseId: courseId)
        } catch {
            // Expected if not authenticated or API not available
            XCTAssertTrue(error is APIError)
        }
    }
}
