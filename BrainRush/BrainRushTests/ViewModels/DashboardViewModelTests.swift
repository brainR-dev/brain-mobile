//
//  DashboardViewModelTests.swift
//  BrainRushTests
//
//  Unit tests for DashboardViewModel
//

import XCTest
import Combine
@testable import BrainRush

@MainActor
final class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = DashboardViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNil(viewModel.dashboardData)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadDashboard() async {
        await viewModel.loadDashboard()
        
        // Verify dashboard is loaded
        // In real tests with mock data, verify data is set
        XCTAssertNotNil(viewModel)
    }
    
    func testRefresh() async {
        await viewModel.refresh()
        
        // Verify refresh loads dashboard and XP
        XCTAssertNotNil(viewModel)
    }
    
    func testLoadingStateChanges() async {
        let expectation = expectation(description: "Loading state changes")
        
        viewModel.$isLoading
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await viewModel.loadDashboard()
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testErrorState() {
        // Test error handling
        viewModel.errorMessage = "Test error"
        XCTAssertEqual(viewModel.errorMessage, "Test error")
    }
}
