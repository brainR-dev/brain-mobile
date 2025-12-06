//
//  Gamification.swift
//  BrainRush
//
//  Gamification models (XP, Achievements, Challenges, Leaderboards)
//

import Foundation

// MARK: - XP & Leveling

struct UserXP: Codable {
    let currentXP: Int
    let level: Int
    let xpToNextLevel: Int
    let lifetimeXP: Int
    
    enum CodingKeys: String, CodingKey {
        case currentXP = "current_xp"
        case level
        case xpToNextLevel = "xp_to_next_level"
        case lifetimeXP = "lifetime_xp"
    }
}

struct XPTransaction: Codable, Identifiable {
    let id: String
    let amount: Int
    let reason: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, amount, reason
        case createdAt = "created_at"
    }
}

// MARK: - Achievements

struct Achievement: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let category: String
    let rarity: String // Common, Uncommon, Rare, Epic, Legendary
    let icon: String?
    let points: Int
    let isUnlocked: Bool?
    let progress: Double? // 0.0 to 1.0
    let unlockedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, category, rarity, icon, points
        case isUnlocked = "is_unlocked"
        case progress
        case unlockedAt = "unlocked_at"
    }
}

// MARK: - Challenges

struct Challenge: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let type: String // daily, weekly, monthly
    let startDate: String
    let endDate: String
    let progress: Double // 0.0 to 1.0
    let target: Int
    let current: Int
    let rewards: ChallengeRewards
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, type
        case startDate = "start_date"
        case endDate = "end_date"
        case progress, target, current, rewards
        case isCompleted = "is_completed"
    }
}

struct ChallengeRewards: Codable {
    let xp: Int
    let tokens: Int
    let items: [String]? // Item IDs
}

// MARK: - Leaderboards

struct Leaderboard: Codable {
    let type: String // global, course, challenge, domain
    let timeframe: String // today, week, month, all-time
    let entries: [LeaderboardEntry]
    let userRank: Int?
    let userEntry: LeaderboardEntry?
    
    enum CodingKeys: String, CodingKey {
        case type, timeframe, entries
        case userRank = "user_rank"
        case userEntry = "user_entry"
    }
}

struct LeaderboardEntry: Codable, Identifiable {
    let id: String
    let userId: String
    let username: String
    let avatar: String?
    let rank: Int
    let score: Int
    let level: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case username, avatar, rank, score, level
    }
}
