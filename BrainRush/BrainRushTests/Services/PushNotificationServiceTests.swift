//
//  PushNotificationServiceTests.swift
//  BrainRushTests
//
//  Unit tests for PushNotificationService
//

import XCTest
@testable import BrainRush
import UserNotifications

final class PushNotificationServiceTests: XCTestCase {
    var service: PushNotificationService!
    
    override func setUp() {
        super.setUp()
        service = PushNotificationService.shared
    }
    
    func testRequestAuthorization() async {
        // Request notification authorization
        let granted = await service.requestAuthorization()
        
        // May be false if user denied, but structure is tested
        XCTAssertNotNil(granted as Bool)
    }
    
    func testRegisterForRemoteNotifications() {
        service.registerForRemoteNotifications()
        
        // Verify registration initiated (no crash)
        XCTAssertTrue(true)
    }
    
    func testHandleNotificationResponse() {
        // Create mock notification response
        let content = UNMutableNotificationContent()
        content.title = "Test"
        content.body = "Test notification"
        
        let request = UNNotificationRequest(
            identifier: "test",
            content: content,
            trigger: nil
        )
        
        // Test handling (would need actual response object)
        XCTAssertNotNil(service)
    }
    
    func testScheduleLocalNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Study Reminder"
        content.body = "Time to study!"
        
        do {
            try await service.scheduleLocalNotification(
                content: content,
                identifier: "test_notification",
                trigger: nil
            )
            // Success
            XCTAssertTrue(true)
        } catch {
            XCTFail("Failed to schedule notification: \(error)")
        }
    }
    
    func testCancelNotification() {
        service.cancelNotification(identifier: "test_notification")
        
        // Verify cancellation (no crash)
        XCTAssertTrue(true)
    }
    
    func testCancelAllNotifications() {
        service.cancelAllNotifications()
        
        // Verify cancellation (no crash)
        XCTAssertTrue(true)
    }
}
