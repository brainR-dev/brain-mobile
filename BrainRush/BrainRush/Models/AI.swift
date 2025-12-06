//
//  AI.swift
//  BrainRush
//
//  AI features models
//

import Foundation

// MARK: - AI Tutor

struct AITutorPersona: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String?
}

struct AITutorMessage: Codable, Identifiable {
    let id: String
    let role: String // user, assistant
    let content: String
    let createdAt: String
    let personaId: String?
    
    enum CodingKeys: String, CodingKey {
        case id, role, content
        case createdAt = "created_at"
        case personaId = "persona_id"
    }
}

struct AITutorQuota: Codable {
    let remaining: Int
    let limit: Int
    let resetAt: String
    
    enum CodingKeys: String, CodingKey {
        case remaining, limit
        case resetAt = "reset_at"
    }
}

// MARK: - AI Study Planner

struct StudySchedule: Codable {
    let id: String
    let sessions: [StudySession]
    let predictions: StudyPredictions?
    
    enum CodingKeys: String, CodingKey {
        case id, sessions, predictions
    }
}

struct StudySession: Codable, Identifiable {
    let id: String
    let courseId: String?
    let title: String
    let startTime: String
    let duration: Int // in minutes
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course_id"
        case title
        case startTime = "start_time"
        case duration
        case isCompleted = "is_completed"
    }
}

struct StudyPredictions: Codable {
    let completionDate: String?
    let riskFactors: [String]
    let confidence: Double // 0.0 to 1.0
    
    enum CodingKeys: String, CodingKey {
        case completionDate = "completion_date"
        case riskFactors = "risk_factors"
        case confidence
    }
}
