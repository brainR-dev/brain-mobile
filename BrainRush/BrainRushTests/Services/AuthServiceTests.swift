//
//  AuthServiceTests.swift
//  BrainRushTests
//
//  Unit tests for AuthService
//

import XCTest
@testable import BrainRush

@MainActor
final class AuthServiceTests: XCTestCase {
    var authService: AuthService!
    
    override func setUp() {
        super.setUp()
        authService = AuthService.shared
    }
    
    override func tearDown() {
        // Clean up test state
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertFalse(authService.isAuthenticated)
        XCTAssertNil(authService.currentUser)
    }
    
    func testSignUp() async throws {
        let email = "test@example.com"
        let password = "password123"
        
        try await authService.signUp(email: email, password: password)
        
        XCTAssertTrue(authService.isAuthenticated)
        XCTAssertNotNil(authService.currentUser)
        XCTAssertEqual(authService.currentUser?.email, email)
    }
    
    func testSignIn() async throws {
        let email = "test@example.com"
        let password = "password123"
        
        try await authService.signIn(email: email, password: password)
        
        XCTAssertTrue(authService.isAuthenticated)
        XCTAssertNotNil(authService.currentUser)
    }
    
    func testSignOut() async throws {
        // First sign in
        try await authService.signIn(email: "test@example.com", password: "password123")
        XCTAssertTrue(authService.isAuthenticated)
        
        // Then sign out
        try await authService.signOut()
        XCTAssertFalse(authService.isAuthenticated)
        XCTAssertNil(authService.currentUser)
    }
    
    func testSessionPersistence() async throws {
        let email = "test@example.com"
        let password = "password123"
        
        // Sign in
        try await authService.signIn(email: email, password: password)
        
        // Check session
        await authService.checkSession()
        
        // Should still be authenticated
        XCTAssertTrue(authService.isAuthenticated)
    }
}
