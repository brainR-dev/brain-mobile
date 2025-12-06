//
//  FormattersTests.swift
//  BrainRushTests
//
//  Unit tests for Formatters utilities
//

import XCTest
@testable import BrainRush

final class FormattersTests: XCTestCase {
    
    func testDurationFormatting() {
        XCTAssertEqual(Formatters.formatDuration(minutes: 30), "30m")
        XCTAssertEqual(Formatters.formatDuration(minutes: 60), "1h")
        XCTAssertEqual(Formatters.formatDuration(minutes: 90), "1h 30m")
        XCTAssertEqual(Formatters.formatDuration(minutes: 120), "2h")
    }
    
    func testXPFormatting() {
        XCTAssertEqual(Formatters.formatXP(500), "500")
        XCTAssertEqual(Formatters.formatXP(1500), "1.5K")
        XCTAssertEqual(Formatters.formatXP(1000000), "1.0M")
        XCTAssertEqual(Formatters.formatXP(2500000), "2.5M")
    }
    
    func testIntExtensions() {
        XCTAssertEqual(30.formattedDuration, "30m")
        XCTAssertEqual(60.formattedDuration, "1h")
        XCTAssertEqual(1500.formattedXP, "1.5K")
        XCTAssertEqual(1000000.formattedXP, "1.0M")
    }
}
