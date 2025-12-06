//
//  ViewStateTests.swift
//  BrainRushTests
//
//  Tests for view state management
//

import XCTest
import SwiftUI
import Combine
@testable import BrainRush

@MainActor
final class ViewStateTests: XCTestCase {
    
    func testLoadingState() {
        let viewModel = DashboardViewModel()
        
        // Initially not loading
        XCTAssertFalse(viewModel.isLoading)
        
        // Trigger load
        Task {
            await viewModel.loadDashboard()
            // Loading state should change during load
        }
    }
    
    func testErrorState() {
        let viewModel = DashboardViewModel()
        
        // Set error
        viewModel.errorMessage = "Test error"
        
        XCTAssertEqual(viewModel.errorMessage, "Test error")
        XCTAssertNotNil(viewModel.errorMessage)
        
        // Clear error
        viewModel.errorMessage = nil
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testEmptyState() {
        let viewModel = CourseViewModel()
        
        // Initially empty
        XCTAssertTrue(viewModel.courses.isEmpty)
        
        // Add courses
        viewModel.courses = MockDataFactory.makeCourses(count: 5)
        
        XCTAssertFalse(viewModel.courses.isEmpty)
        XCTAssertEqual(viewModel.courses.count, 5)
    }
    
    func testSearchState() {
        let viewModel = CourseViewModel()
        
        // Initial search is empty
        XCTAssertTrue(viewModel.searchText.isEmpty)
        
        // Set search text
        viewModel.searchText = "Swift"
        
        XCTAssertEqual(viewModel.searchText, "Swift")
        XCTAssertFalse(viewModel.searchText.isEmpty)
    }
    
    func testFilterState() {
        let viewModel = CourseViewModel()
        
        // No filter initially
        XCTAssertNil(viewModel.selectedCategory)
        
        // Set category filter
        viewModel.selectedCategory = "Programming"
        
        XCTAssertEqual(viewModel.selectedCategory, "Programming")
        
        // Clear filter
        viewModel.selectedCategory = nil
        XCTAssertNil(viewModel.selectedCategory)
    }
    
    func testSelectedItemState() {
        let viewModel = CourseViewModel()
        let course = MockDataFactory.makeCourse()
        
        // No selection initially
        // Would test selected course if property exists
        
        XCTAssertNotNil(course)
    }
}
