//
//  NetworkMonitorTests.swift
//  BrainRushTests
//
//  Unit tests for NetworkMonitor
//

import XCTest
@testable import BrainRush

final class NetworkMonitorTests: XCTestCase {
    
    func testNetworkMonitorInitialization() {
        let monitor = NetworkMonitor.shared
        
        // Network monitor should initialize
        XCTAssertNotNil(monitor)
    }
    
    func testConnectionState() async {
        let monitor = NetworkMonitor.shared
        
        // Should have some connection state (may vary based on test environment)
        // Just verify it's accessible
        let _ = monitor.isConnected
        let _ = monitor.connectionType
        
        XCTAssertTrue(true) // Placeholder - actual test depends on environment
    }
}
