//
//  ComponentTests.swift
//  BrainRushTests
//
//  Unit tests for reusable components
//

import XCTest
import SwiftUI
@testable import BrainRush

final class ComponentTests: XCTestCase {
    
    func testValidationHelper() {
        // Test validation utilities work with components
        let validEmail = "test@example.com"
        XCTAssertTrue(Validation.isValidEmail(validEmail))
    }
    
    func testFormatterHelpers() {
        // Test formatters work correctly
        let duration = Formatters.formatDuration(minutes: 90)
        XCTAssertEqual(duration, "1h 30m")
        
        let xp = Formatters.formatXP(1500)
        XCTAssertEqual(xp, "1.5K")
    }
    
    func testHapticFeedback() {
        // Test haptic feedback types
        HapticFeedback.light.play()
        HapticFeedback.success.play()
        
        // If no crash, test passes
        XCTAssertTrue(true)
    }
}
