//
//  CourseViewModelTests.swift
//  BrainRushTests
//
//  Unit tests for CourseViewModel
//

import XCTest
import Combine
@testable import BrainRush

@MainActor
final class CourseViewModelTests: XCTestCase {
    var viewModel: CourseViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = CourseViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.courses.isEmpty)
        XCTAssertTrue(viewModel.filteredCourses.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertNil(viewModel.selectedCategory)
    }
    
    func testSearchFilter() {
        // Add some mock courses
        let course1 = Course(
            id: "1",
            title: "Swift Programming",
            description: "Learn Swift",
            thumbnail: nil,
            instructor: nil,
            duration: nil,
            rating: nil,
            reviewCount: nil,
            enrollmentCount: nil,
            difficulty: nil,
            category: "Programming",
            domain: nil,
            brainWaveLevel: nil,
            sections: nil,
            progress: nil
        )
        
        viewModel.courses = [course1]
        
        // Set search text
        viewModel.searchText = "Swift"
        
        // Wait for Combine pipeline
        let expectation = expectation(description: "Filter courses")
        
        viewModel.$filteredCourses
            .dropFirst()
            .sink { courses in
                XCTAssertFalse(courses.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testCategoryFilter() {
        let course1 = Course(
            id: "1",
            title: "Swift Programming",
            description: nil,
            thumbnail: nil,
            instructor: nil,
            duration: nil,
            rating: nil,
            reviewCount: nil,
            enrollmentCount: nil,
            difficulty: nil,
            category: "Programming",
            domain: nil,
            brainWaveLevel: nil,
            sections: nil,
            progress: nil
        )
        
        viewModel.courses = [course1]
        viewModel.selectedCategory = "Programming"
        
        let expectation = expectation(description: "Filter by category")
        
        viewModel.$filteredCourses
            .dropFirst()
            .sink { courses in
                XCTAssertEqual(courses.count, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
}
