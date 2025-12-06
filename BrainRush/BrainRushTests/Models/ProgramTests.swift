//
//  ProgramTests.swift
//  BrainRushTests
//
//  Unit tests for Program models
//

import XCTest
@testable import BrainRush

final class ProgramTests: XCTestCase {
    
    func testProgramDecoding() throws {
        let json = """
        {
            "id": "program_1",
            "name": "Computer Science Degree",
            "description": "Complete CS degree program",
            "domain": "Computer Science",
            "degree_type": "Bachelor's",
            "duration": 48,
            "enrollment_count": 500,
            "courses": [],
            "progress": {
                "completion_percentage": 0.5,
                "courses_completed": 10,
                "total_courses": 20
            }
        }
        """
        
        let program = try TestHelpers.decodeJSON(json, as: Program.self)
        
        XCTAssertEqual(program.id, "program_1")
        XCTAssertEqual(program.name, "Computer Science Degree")
        XCTAssertEqual(program.domain, "Computer Science")
        XCTAssertEqual(program.degreeType, "Bachelor's")
        XCTAssertEqual(program.duration, 48)
        XCTAssertEqual(program.enrollmentCount, 500)
        XCTAssertNotNil(program.progress)
        XCTAssertEqual(program.progress?.completionPercentage, 0.5, accuracy: 0.01)
    }
    
    func testProgramCourseDecoding() throws {
        let json = """
        {
            "id": "pc_1",
            "course_id": "course_1",
            "title": "Introduction to Programming",
            "is_required": true,
            "order": 1
        }
        """
        
        let programCourse = try TestHelpers.decodeJSON(json, as: ProgramCourse.self)
        
        XCTAssertEqual(programCourse.id, "pc_1")
        XCTAssertEqual(programCourse.courseId, "course_1")
        XCTAssertTrue(programCourse.isRequired)
        XCTAssertEqual(programCourse.order, 1)
    }
    
    func testProgramProgressDecoding() throws {
        let json = """
        {
            "completion_percentage": 0.75,
            "courses_completed": 15,
            "total_courses": 20
        }
        """
        
        let progress = try TestHelpers.decodeJSON(json, as: ProgramProgress.self)
        
        XCTAssertEqual(progress.completionPercentage, 0.75, accuracy: 0.01)
        XCTAssertEqual(progress.coursesCompleted, 15)
        XCTAssertEqual(progress.totalCourses, 20)
    }
}
