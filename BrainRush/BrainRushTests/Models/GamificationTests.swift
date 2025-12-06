//
//  GamificationTests.swift
//  BrainRushTests
//
//  Unit tests for Gamification models
//

import XCTest
@testable import BrainRush

final class GamificationTests: XCTestCase {
    
    func testUserXPDecoding() throws {
        let json = """
        {
            "current_xp": 750,
            "level": 12,
            "xp_to_next_level": 250,
            "lifetime_xp": 5000
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let xp = try decoder.decode(UserXP.self, from: data)
        
        XCTAssertEqual(xp.currentXP, 750)
        XCTAssertEqual(xp.level, 12)
        XCTAssertEqual(xp.xpToNextLevel, 250)
        XCTAssertEqual(xp.lifetimeXP, 5000)
    }
    
    func testAchievementDecoding() throws {
        let json = """
        {
            "id": "ach_1",
            "name": "First Steps",
            "description": "Complete your first lesson",
            "category": "getting_started",
            "rarity": "Rare",
            "icon": "trophy.fill",
            "points": 10,
            "is_unlocked": true,
            "progress": 1.0,
            "unlocked_at": "2024-01-01T00:00:00Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let achievement = try decoder.decode(Achievement.self, from: data)
        
        XCTAssertEqual(achievement.id, "ach_1")
        XCTAssertEqual(achievement.name, "First Steps")
        XCTAssertEqual(achievement.category, "getting_started")
        XCTAssertEqual(achievement.rarity, "Rare")
        XCTAssertEqual(achievement.points, 10)
        XCTAssertTrue(achievement.isUnlocked == true)
        XCTAssertEqual(achievement.progress, 1.0)
    }
    
    func testChallengeDecoding() throws {
        let json = """
        {
            "id": "challenge_1",
            "name": "Daily Study",
            "description": "Study for 30 minutes",
            "type": "daily",
            "start_date": "2024-01-01T00:00:00Z",
            "end_date": "2024-01-02T00:00:00Z",
            "progress": 0.5,
            "target": 30,
            "current": 15,
            "rewards": {
                "xp": 100,
                "tokens": 50
            },
            "is_completed": false
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let challenge = try decoder.decode(Challenge.self, from: data)
        
        XCTAssertEqual(challenge.id, "challenge_1")
        XCTAssertEqual(challenge.type, "daily")
        XCTAssertEqual(challenge.target, 30)
        XCTAssertEqual(challenge.current, 15)
        XCTAssertEqual(challenge.progress, 0.5)
        XCTAssertEqual(challenge.rewards.xp, 100)
        XCTAssertEqual(challenge.rewards.tokens, 50)
        XCTAssertFalse(challenge.isCompleted)
    }
}
