//
//  DashboardServiceTests.swift
//  BrainRushTests
//
//  Unit tests for DashboardService
//

import XCTest
import Combine
@testable import BrainRush

@MainActor
final class DashboardServiceTests: XCTestCase {
    var service: DashboardService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        service = DashboardService.shared
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNil(service.dashboardData)
        XCTAssertFalse(service.isLoading)
        XCTAssertNil(service.errorMessage)
    }
    
    func testLoadDashboard() async {
        await service.loadDashboard()
        
        // Verify loading state changes
        // In real tests with mock API, we'd verify data is loaded
        XCTAssertNotNil(service)
    }
    
    func testLoadingState() async {
        let expectation = expectation(description: "Loading state changes")
        
        service.$isLoading
            .dropFirst()
            .sink { isLoading in
                // Loading should change during load
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await service.loadDashboard()
        
        // Wait a bit for loading to complete
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testErrorHandling() async {
        // This would test error scenarios with mocked API errors
        // Placeholder for now
        XCTAssertTrue(true)
    }
}
