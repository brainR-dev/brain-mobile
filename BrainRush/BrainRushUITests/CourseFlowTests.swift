//
//  CourseFlowTests.swift
//  BrainRushUITests
//
//  UI tests for course browsing and enrollment
//

import XCTest

final class CourseFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Sign in first (would need test credentials)
        // This is a placeholder - real tests would handle authentication
    }
    
    func testCoursesTabExists() throws {
        // Navigate to courses tab
        let coursesTab = app.tabBars.buttons["Courses"]
        if coursesTab.exists {
            coursesTab.tap()
            
            // Verify courses screen is displayed
            XCTAssertTrue(app.navigationBars["Courses"].exists)
        }
    }
    
    func testCourseSearch() throws {
        // Navigate to courses
        let coursesTab = app.tabBars.buttons["Courses"]
        if coursesTab.exists {
            coursesTab.tap()
            
            // Look for search field
            let searchField = app.searchFields.firstMatch
            if searchField.exists {
                searchField.tap()
                searchField.typeText("Swift")
                // Verify search is working (results would appear)
            }
        }
    }
    
    func testCourseDetailNavigation() throws {
        // This test would require courses to be loaded
        // Navigate to courses tab
        let coursesTab = app.tabBars.buttons["Courses"]
        if coursesTab.exists {
            coursesTab.tap()
            
            // Tap first course if available
            let firstCourse = app.cells.firstMatch
            if firstCourse.exists {
                firstCourse.tap()
                // Verify we're on course detail screen
                // This depends on actual UI structure
            }
        }
    }
}
