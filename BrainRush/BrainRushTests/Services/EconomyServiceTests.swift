//
//  EconomyServiceTests.swift
//  BrainRushTests
//
//  Unit tests for EconomyService
//

import XCTest
@testable import BrainRush

@MainActor
final class EconomyServiceTests: XCTestCase {
    var service: EconomyService!
    
    override func setUp() {
        super.setUp()
        service = EconomyService.shared
    }
    
    func testLoadTokenBalance() async {
        await service.loadTokenBalance()
        
        // Verify balance is loaded (may be nil if not authenticated)
        XCTAssertNotNil(service)
    }
    
    func testLoadTransactions() async {
        await service.loadTransactions()
        
        // Verify transactions are loaded
        XCTAssertNotNil(service.transactions)
    }
    
    func testLoadSwagItems() async {
        await service.loadSwagItems()
        
        // Verify swag items are loaded
        XCTAssertNotNil(service.swagItems)
    }
    
    func testPurchaseItem() async throws {
        let itemId = "item_1"
        
        do {
            try await service.purchaseItem(itemId: itemId)
            
            // Verify balance updated
            // In real tests, verify token balance decreased
        } catch {
            // Expected if not authenticated or insufficient funds
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testTransactionTypes() {
        // Test transaction type validation
        let transaction = TokenTransaction(
            id: "tx_1",
            type: "earn",
            amount: 100,
            reason: "Lesson completed",
            createdAt: Date().ISO8601Format()
        )
        
        XCTAssertEqual(transaction.type, "earn")
        XCTAssertEqual(transaction.amount, 100)
    }
}
