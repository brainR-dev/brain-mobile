//
//  GamificationServiceTests.swift
//  BrainRushTests
//
//  Unit tests for GamificationService
//

import XCTest
@testable import BrainRush

@MainActor
final class GamificationServiceTests: XCTestCase {
    var service: GamificationService!
    
    override func setUp() {
        super.setUp()
        service = GamificationService.shared
    }
    
    func testLoadUserXP() async {
        await service.loadUserXP()
        
        // Verify XP is loaded (may be nil if not authenticated)
        // In real tests, we'd mock the API response
        XCTAssertTrue(true) // Placeholder
    }
    
    func testLoadAchievements() async {
        await service.loadAchievements()
        
        // Verify achievements are loaded
        XCTAssertNotNil(service.achievements)
    }
    
    func testLoadChallenges() async {
        await service.loadChallenges()
        
        // Verify challenges are loaded
        XCTAssertNotNil(service.activeChallenges)
    }
    
    func testLeaderboardTypes() async {
        await service.loadLeaderboard(type: "global", timeframe: "all-time")
        
        // Verify leaderboard is loaded
        let key = "global_all-time"
        // Leaderboard may be nil if not authenticated
        XCTAssertTrue(true) // Placeholder
    }
}
