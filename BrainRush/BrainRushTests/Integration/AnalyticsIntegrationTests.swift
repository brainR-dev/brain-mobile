//
//  AnalyticsIntegrationTests.swift
//  BrainRushTests
//
//  Integration tests for analytics
//

import XCTest
@testable import BrainRush

final class AnalyticsIntegrationTests: XCTestCase {
    
    func testAnalyticsServiceInitialization() {
        let analytics = AnalyticsService.shared
        XCTAssertNotNil(analytics)
    }
    
    func testEventTracking() {
        AnalyticsService.shared.track("test_event", properties: ["key": "value"])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testScreenTracking() {
        AnalyticsService.shared.trackScreen("test_screen", properties: ["context": "test"])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testErrorTracking() {
        let error = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        AnalyticsService.shared.trackError(error, context: ["action": "test"])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testUserIdentification() {
        AnalyticsService.shared.identify(userId: "test_user", properties: ["email": "test@example.com"])
        
        // Verify no crash
        XCTAssertTrue(true)
    }
}
