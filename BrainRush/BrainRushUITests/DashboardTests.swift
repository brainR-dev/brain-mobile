//
//  DashboardTests.swift
//  BrainRushUITests
//
//  UI tests for dashboard
//

import XCTest

final class DashboardTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testDashboardAppears() throws {
        // After authentication, dashboard should appear
        // This is a placeholder test structure
        let dashboard = app.navigationBars["BrainRush"]
        
        // If authenticated, dashboard should exist
        // Otherwise, sign in screen should exist
        XCTAssertTrue(dashboard.exists || app.textFields["Email"].exists)
    }
    
    func testDashboardRefresh() throws {
        // Test pull-to-refresh on dashboard
        let dashboard = app.navigationBars["BrainRush"]
        if dashboard.exists {
            // Perform pull to refresh gesture
            let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
            let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
            start.press(forDuration: 0, thenDragTo: end)
            
            // Verify refresh happens (would check loading indicator)
        }
    }
}
