//
//  KeychainServiceTests.swift
//  BrainRushTests
//
//  Unit tests for KeychainService
//

import XCTest
@testable import BrainRush

final class KeychainServiceTests: XCTestCase {
    var keychain: KeychainService!
    
    override func setUp() {
        super.setUp()
        keychain = KeychainService.shared
    }
    
    override func tearDown() {
        // Clean up test data
        keychain.clearAll()
        super.tearDown()
    }
    
    func testSaveAndRetrieveAccessToken() {
        let token = "test_access_token_123"
        keychain.saveAccessToken(token)
        
        let retrieved = keychain.getAccessToken()
        XCTAssertEqual(retrieved, token)
    }
    
    func testSaveAndRetrieveRefreshToken() {
        let token = "test_refresh_token_123"
        keychain.saveRefreshToken(token)
        
        let retrieved = keychain.getRefreshToken()
        XCTAssertEqual(retrieved, token)
    }
    
    func testSaveAndRetrieveUserId() {
        let userId = "user_123"
        keychain.saveUserId(userId)
        
        let retrieved = keychain.getUserId()
        XCTAssertEqual(retrieved, userId)
    }
    
    func testSaveAndRetrieveEmail() {
        let email = "test@example.com"
        keychain.saveEmail(email)
        
        let retrieved = keychain.getEmail()
        XCTAssertEqual(retrieved, email)
    }
    
    func testClearAll() {
        keychain.saveAccessToken("test_token")
        keychain.saveUserId("test_user")
        
        keychain.clearAll()
        
        XCTAssertNil(keychain.getAccessToken())
        XCTAssertNil(keychain.getUserId())
    }
}
