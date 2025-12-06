//
//  Economy.swift
//  BrainRush
//
//  Virtual economy models (Tokens, Swag, Avatar)
//

import Foundation

// MARK: - Tokens

struct TokenBalance: Codable {
    let balance: Int
    let totalEarned: Int
    let totalSpent: Int
    
    enum CodingKeys: String, CodingKey {
        case balance
        case totalEarned = "total_earned"
        case totalSpent = "total_spent"
    }
}

struct TokenTransaction: Codable, Identifiable {
    let id: String
    let type: String // earn, spend, redeem
    let amount: Int
    let reason: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, type, amount, reason
        case createdAt = "created_at"
    }
}

// MARK: - Swag Store

struct SwagItem: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let category: String // hats, clothing, accessories, backgrounds
    let rarity: String // Common, Uncommon, Rare, Epic, Legendary, Mythic
    let price: Int // in tokens
    let image: String?
    let isOwned: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, category, rarity, price, image
        case isOwned = "is_owned"
    }
}

// MARK: - Avatar

struct UserAvatar: Codable {
    let userId: String
    let items: [AvatarItem]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case items
    }
}

struct AvatarItem: Codable {
    let itemId: String
    let category: String
    let isEquipped: Bool
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case category
        case isEquipped = "is_equipped"
    }
}
