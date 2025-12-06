//
//  CourseTests.swift
//  BrainRushTests
//
//  Unit tests for Course model
//

import XCTest
@testable import BrainRush

final class CourseTests: XCTestCase {
    
    func testCourseDecoding() throws {
        let json = """
        {
            "id": "course_123",
            "title": "Introduction to Swift",
            "description": "Learn Swift programming",
            "instructor": "John Doe",
            "duration": 120,
            "rating": 4.5,
            "review_count": 150,
            "enrollment_count": 1000,
            "difficulty": "beginner",
            "category": "Programming",
            "domain": "Computer Science",
            "brain_wave_level": "alpha"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let course = try decoder.decode(Course.self, from: data)
        
        XCTAssertEqual(course.id, "course_123")
        XCTAssertEqual(course.title, "Introduction to Swift")
        XCTAssertEqual(course.description, "Learn Swift programming")
        XCTAssertEqual(course.instructor, "John Doe")
        XCTAssertEqual(course.duration, 120)
        XCTAssertEqual(course.rating, 4.5)
        XCTAssertEqual(course.reviewCount, 150)
        XCTAssertEqual(course.enrollmentCount, 1000)
        XCTAssertEqual(course.difficulty, "beginner")
        XCTAssertEqual(course.category, "Programming")
        XCTAssertEqual(course.domain, "Computer Science")
    }
    
    func testCourseWithSections() throws {
        let json = """
        {
            "id": "course_456",
            "title": "Advanced iOS Development",
            "sections": [
                {
                    "id": "section_1",
                    "title": "Getting Started",
                    "order": 1,
                    "lessons": [
                        {
                            "id": "lesson_1",
                            "course_id": "course_456",
                            "title": "Introduction",
                            "type": "video",
                            "duration": 10,
                            "order": 1
                        }
                    ]
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let course = try decoder.decode(Course.self, from: data)
        
        XCTAssertEqual(course.id, "course_456")
        XCTAssertNotNil(course.sections)
        XCTAssertEqual(course.sections?.count, 1)
        XCTAssertEqual(course.sections?.first?.title, "Getting Started")
        XCTAssertEqual(course.sections?.first?.lessons?.count, 1)
    }
}
