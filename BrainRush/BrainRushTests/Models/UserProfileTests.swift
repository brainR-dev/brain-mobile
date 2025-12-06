//
//  UserProfileTests.swift
//  BrainRushTests
//
//  Unit tests for UserProfile model
//

import XCTest
@testable import BrainRush

final class UserProfileTests: XCTestCase {
    
    func testUserProfileCreation() {
        let profile = MockDataFactory.makeUserProfile(
            id: "user_123",
            email: "test@example.com",
            hasCompletedBrainProfile: true
        )
        
        XCTAssertEqual(profile.id, "user_123")
        XCTAssertEqual(profile.email, "test@example.com")
        XCTAssertTrue(profile.hasCompletedBrainProfile)
    }
    
    func testUserProfileDecoding() throws {
        let json = """
        {
            "id": "user_1",
            "email": "test@example.com",
            "username": "testuser",
            "avatar": null,
            "created_at": "2024-01-01T00:00:00Z",
            "has_completed_brain_profile": false
        }
        """
        
        let profile = try TestHelpers.decodeJSON(json, as: UserProfile.self)
        
        XCTAssertEqual(profile.id, "user_1")
        XCTAssertEqual(profile.email, "test@example.com")
        XCTAssertEqual(profile.username, "testuser")
        XCTAssertFalse(profile.hasCompletedBrainProfile)
    }
}
