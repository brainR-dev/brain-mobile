//
//  BrainProfile.swift
//  BrainRush
//
//  Brain Profile model
//

import Foundation

struct BrainProfile: Codable {
    let userId: String
    let scores: BrainDomainScores
    let insights: BrainProfileInsights?
    let recommendations: [String]?
    let completedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case scores, insights, recommendations
        case completedAt = "completed_at"
    }
}

struct BrainDomainScores: Codable {
    let analytical: Double // 0.0 to 1.0
    let creative: Double
    let practical: Double
    let theoretical: Double
    let intuitive: Double
    let structured: Double
}

struct BrainProfileInsights: Codable {
    let learningStyle: String
    let strengths: [String]
    let growthAreas: [String]
    let recommendations: [String]
    
    enum CodingKeys: String, CodingKey {
        case learningStyle = "learning_style"
        case strengths
        case growthAreas = "growth_areas"
        case recommendations
    }
}
