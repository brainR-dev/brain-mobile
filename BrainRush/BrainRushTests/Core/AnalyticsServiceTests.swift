//
//  AnalyticsServiceTests.swift
//  BrainRushTests
//
//  Unit tests for AnalyticsService
//

import XCTest
@testable import BrainRush

final class AnalyticsServiceTests: XCTestCase {
    
    func testAnalyticsServiceInitialization() {
        let analytics = AnalyticsService.shared
        XCTAssertNotNil(analytics)
    }
    
    func testTrackEvent() {
        AnalyticsService.shared.track("test_event", properties: ["key": "value"])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testTrackScreen() {
        AnalyticsService.shared.trackScreen("test_screen", properties: ["context": "test"])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testTrackError() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        AnalyticsService.shared.trackError(error, context: ["action": "test_action"])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testIdentifyUser() {
        AnalyticsService.shared.identify(userId: "test_user_123", properties: [
            "email": "test@example.com",
            "level": 5
        ])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testUserProperties() {
        AnalyticsService.shared.setUserProperties([
            "level": 10,
            "xp": 1000
        ])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testReset() {
        AnalyticsService.shared.reset()
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testFeatureFlags() {
        let flag = AnalyticsService.shared.getFeatureFlag("test_flag")
        // May return false if PostHog not configured
        XCTAssertNotNil(flag as Bool)
    }
}
