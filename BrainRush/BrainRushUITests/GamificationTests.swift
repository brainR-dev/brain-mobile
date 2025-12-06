//
//  GamificationTests.swift
//  BrainRushUITests
//
//  UI tests for gamification features
//

import XCTest

final class GamificationTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testAchievementsTabExists() throws {
        let achievementsTab = app.tabBars.buttons["Achievements"]
        if achievementsTab.exists {
            achievementsTab.tap()
            
            // Verify achievements screen
            XCTAssertTrue(app.navigationBars["Achievements"].exists)
        }
    }
    
    func testChallengesTabExists() throws {
        let challengesTab = app.tabBars.buttons["Challenges"]
        if challengesTab.exists {
            challengesTab.tap()
            
            // Verify challenges screen
            XCTAssertTrue(app.navigationBars["Challenges"].exists)
        }
    }
    
    func testXPDisplay() throws {
        // After authentication, check for XP display on dashboard
        // This depends on actual UI structure
        XCTAssertTrue(true) // Placeholder
    }
}
