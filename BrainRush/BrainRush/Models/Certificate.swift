//
//  Certificate.swift
//  BrainRush
//
//  Certificate and credential models
//

import Foundation

struct Certificate: Codable, Identifiable {
    let id: String
    let type: String // course, program, skill
    let title: String
    let courseId: String?
    let programId: String?
    let issuedAt: String
    let verificationUrl: String
    let pdfUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, title
        case courseId = "course_id"
        case programId = "program_id"
        case issuedAt = "issued_at"
        case verificationUrl = "verification_url"
        case pdfUrl = "pdf_url"
    }
}

struct Badge: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let skill: String
    let icon: String?
    let earnedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, skill, icon
        case earnedAt = "earned_at"
    }
}
