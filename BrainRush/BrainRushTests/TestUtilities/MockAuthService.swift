//
//  MockAuthService.swift
//  BrainRushTests
//
//  Mock authentication service for testing
//

import Foundation
@testable import BrainRush

@MainActor
class MockAuthService: AuthService {
    static var mockInstance: MockAuthService?
    
    var shouldFailSignIn = false
    var shouldFailSignUp = false
    var mockUser: User?
    var mockSession: Session?
    
    override init() {
        super.init()
    }
    
    override func signIn(email: String, password: String) async throws {
        if shouldFailSignIn {
            throw APIError.unauthorized
        }
        
        // Create mock session
        let userId = UUID().uuidString
        let token = "mock_token_\(UUID().uuidString)"
        
        mockSession = Session(
            accessToken: token,
            refreshToken: "refresh_\(token)",
            expiresIn: 3600,
            user: User(id: userId, email: email, createdAt: Date().ISO8601Format())
        )
        
        currentUser = mockSession?.user
        session = mockSession
        isAuthenticated = true
    }
    
    override func signUp(email: String, password: String) async throws {
        if shouldFailSignUp {
            throw APIError.serverError(400, "Email already exists")
        }
        
        // Create mock session
        let userId = UUID().uuidString
        let token = "mock_token_\(UUID().uuidString)"
        
        mockSession = Session(
            accessToken: token,
            refreshToken: "refresh_\(token)",
            expiresIn: 3600,
            user: User(id: userId, email: email, createdAt: Date().ISO8601Format())
        )
        
        currentUser = mockSession?.user
        session = mockSession
        isAuthenticated = true
    }
    
    override func getAccessToken() -> String? {
        return mockSession?.accessToken
    }
}
