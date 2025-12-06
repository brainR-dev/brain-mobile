//
//  Dashboard.swift
//  BrainRush
//
//  Dashboard data models
//

import Foundation

struct DashboardData: Codable {
    let continueLearning: ContinueLearning?
    let recommendedCourses: [Course]
    let recentActivity: [ActivityItem]
    let quickStats: QuickStats
    let upcomingDeadlines: [Deadline]
    
    enum CodingKeys: String, CodingKey {
        case continueLearning = "continue_learning"
        case recommendedCourses = "recommended_courses"
        case recentActivity = "recent_activity"
        case quickStats = "quick_stats"
        case upcomingDeadlines = "upcoming_deadlines"
    }
}

struct ContinueLearning: Codable {
    let courseId: String
    let courseTitle: String
    let lessonId: String
    let lessonTitle: String
    let progress: Double
    
    enum CodingKeys: String, CodingKey {
        case courseId = "course_id"
        case courseTitle = "course_title"
        case lessonId = "lesson_id"
        case lessonTitle = "lesson_title"
        case progress
    }
}

struct ActivityItem: Codable, Identifiable {
    let id: String
    let type: String // lesson_completed, achievement_unlocked, level_up, etc.
    let title: String
    let description: String?
    let timestamp: String
    let metadata: [String: String]?
}

struct QuickStats: Codable {
    let coursesInProgress: Int
    let coursesCompleted: Int
    let currentXP: Int
    let currentLevel: Int
    let studyStreak: Int
    
    enum CodingKeys: String, CodingKey {
        case coursesInProgress = "courses_in_progress"
        case coursesCompleted = "courses_completed"
        case currentXP = "current_xp"
        case currentLevel = "current_level"
        case studyStreak = "study_streak"
    }
}

struct Deadline: Codable, Identifiable {
    let id: String
    let type: String // assignment, challenge, etc.
    let title: String
    let dueDate: String
    let courseId: String?
    let courseTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, title
        case dueDate = "due_date"
        case courseId = "course_id"
        case courseTitle = "course_title"
    }
}
