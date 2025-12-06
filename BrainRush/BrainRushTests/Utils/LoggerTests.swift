//
//  LoggerTests.swift
//  BrainRushTests
//
//  Unit tests for Logger
//

import XCTest
@testable import BrainRush

final class LoggerTests: XCTestCase {
    
    func testLoggerInitialization() {
        let logger = Logger.shared
        XCTAssertNotNil(logger)
    }
    
    func testLogLevels() {
        // Test all log levels don't crash
        Logger.shared.debug("Debug message")
        Logger.shared.info("Info message")
        Logger.shared.warning("Warning message")
        Logger.shared.error("Error message")
        
        // If no crash, test passes
        XCTAssertTrue(true)
    }
    
    func testLogWithContext() {
        Logger.shared.log("Test message", level: .info, file: #file, function: #function, line: #line)
        
        // Verify no crash
        XCTAssertTrue(true)
    }
}
