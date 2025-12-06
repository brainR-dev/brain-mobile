//
//  HapticFeedbackTests.swift
//  BrainRushTests
//
//  Unit tests for HapticFeedback
//

import XCTest
@testable import BrainRush

final class HapticFeedbackTests: XCTestCase {
    
    func testHapticFeedbackTypes() {
        // Test all haptic feedback types don't crash
        HapticFeedback.light.play()
        HapticFeedback.medium.play()
        HapticFeedback.heavy.play()
        HapticFeedback.success.play()
        HapticFeedback.warning.play()
        HapticFeedback.error.play()
        
        // If no crash, test passes
        XCTAssertTrue(true)
    }
    
    func testHapticFeedbackSequence() {
        // Test playing multiple haptics
        HapticFeedback.light.play()
        
        // Wait briefly
        Thread.sleep(forTimeInterval: 0.1)
        
        HapticFeedback.success.play()
        
        // If no crash, test passes
        XCTAssertTrue(true)
    }
}
