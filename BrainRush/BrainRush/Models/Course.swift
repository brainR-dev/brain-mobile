//
//  Course.swift
//  BrainRush
//
//  Course model
//

import Foundation

struct Course: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let thumbnail: String?
    let instructor: String?
    let duration: Int? // in minutes
    let rating: Double?
    let reviewCount: Int?
    let enrollmentCount: Int?
    let difficulty: String?
    let category: String?
    let domain: String?
    let brainWaveLevel: String?
    let sections: [CourseSection]?
    let progress: CourseProgress?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description, thumbnail, instructor, duration, rating
        case reviewCount = "review_count"
        case enrollmentCount = "enrollment_count"
        case difficulty, category, domain
        case brainWaveLevel = "brain_wave_level"
        case sections, progress
    }
}

struct CourseSection: Codable, Identifiable {
    let id: String
    let title: String
    let order: Int
    let lessons: [Lesson]?
}

struct Lesson: Codable, Identifiable {
    let id: String
    let courseId: String
    let sectionId: String?
    let title: String
    let description: String?
    let type: String // video, text, quiz, etc.
    let duration: Int? // in minutes
    let videoUrl: String?
    let content: String?
    let order: Int
    let isCompleted: Bool?
    let progress: Double? // 0.0 to 1.0
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course_id"
        case sectionId = "section_id"
        case title, description, type, duration
        case videoUrl = "video_url"
        case content, order
        case isCompleted = "is_completed"
        case progress
    }
}

struct CourseProgress: Codable {
    let overallProgress: Double // 0.0 to 1.0
    let lessonsCompleted: Int
    let totalLessons: Int
    let timeSpent: Int? // in minutes
    let lastAccessedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case overallProgress = "overall_progress"
        case lessonsCompleted = "lessons_completed"
        case totalLessons = "total_lessons"
        case timeSpent = "time_spent"
        case lastAccessedAt = "last_accessed_at"
    }
}
