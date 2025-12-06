//
//  EconomyTests.swift
//  BrainRushTests
//
//  Unit tests for Economy models
//

import XCTest
@testable import BrainRush

final class EconomyTests: XCTestCase {
    
    func testTokenBalanceDecoding() throws {
        let json = """
        {
            "balance": 1000,
            "total_earned": 5000,
            "total_spent": 4000
        }
        """
        
        let balance = try TestHelpers.decodeJSON(json, as: TokenBalance.self)
        
        XCTAssertEqual(balance.balance, 1000)
        XCTAssertEqual(balance.totalEarned, 5000)
        XCTAssertEqual(balance.totalSpent, 4000)
    }
    
    func testSwagItemDecoding() throws {
        let json = """
        {
            "id": "item_1",
            "name": "Cool Hat",
            "description": "A cool hat",
            "category": "hats",
            "rarity": "Rare",
            "price": 500,
            "image": null,
            "is_owned": false
        }
        """
        
        let item = try TestHelpers.decodeJSON(json, as: SwagItem.self)
        
        XCTAssertEqual(item.id, "item_1")
        XCTAssertEqual(item.name, "Cool Hat")
        XCTAssertEqual(item.category, "hats")
        XCTAssertEqual(item.rarity, "Rare")
        XCTAssertEqual(item.price, 500)
        XCTAssertFalse(item.isOwned ?? true)
    }
    
    func testTokenTransactionDecoding() throws {
        let json = """
        {
            "id": "tx_1",
            "type": "earn",
            "amount": 100,
            "reason": "Lesson completed",
            "created_at": "2024-01-01T00:00:00Z"
        }
        """
        
        let transaction = try TestHelpers.decodeJSON(json, as: TokenTransaction.self)
        
        XCTAssertEqual(transaction.id, "tx_1")
        XCTAssertEqual(transaction.type, "earn")
        XCTAssertEqual(transaction.amount, 100)
        XCTAssertEqual(transaction.reason, "Lesson completed")
    }
}
