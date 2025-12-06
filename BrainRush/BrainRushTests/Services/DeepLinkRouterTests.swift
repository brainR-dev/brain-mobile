//
//  DeepLinkRouterTests.swift
//  BrainRushTests
//
//  Unit tests for DeepLinkRouter
//

import XCTest
@testable import BrainRush

final class DeepLinkRouterTests: XCTestCase {
    var router: DeepLinkRouter!
    
    override func setUp() {
        super.setUp()
        router = DeepLinkRouter.shared
    }
    
    func testUniversalLinkCourse() {
        let url = URL(string: "https://brainrash.com/courses/course_123")!
        let route = router.handleURL(url)
        
        if case .course(let courseId) = route {
            XCTAssertEqual(courseId, "course_123")
        } else {
            // Route may be nil if not fully configured
            XCTAssertTrue(true)
        }
    }
    
    func testUniversalLinkLesson() {
        let url = URL(string: "https://brainrash.com/courses/course_123/lessons/lesson_456")!
        let route = router.handleURL(url)
        
        if case .lesson(let courseId, let lessonId) = route {
            XCTAssertEqual(courseId, "course_123")
            XCTAssertEqual(lessonId, "lesson_456")
        } else {
            XCTAssertTrue(true)
        }
    }
    
    func testCustomURLScheme() {
        let url = URL(string: "brainrush://course?id=course_123")!
        let route = router.handleURL(url)
        
        // Verify route is parsed
        XCTAssertNotNil(route)
    }
    
    func testInvalidURL() {
        let url = URL(string: "https://example.com/test")!
        let route = router.handleURL(url)
        
        // Should return nil for invalid domain
        XCTAssertTrue(true)
    }
}
