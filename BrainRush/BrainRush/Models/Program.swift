//
//  Program.swift
//  BrainRush
//
//  Degree program model
//

import Foundation

struct Program: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let domain: String
    let degreeType: String // Bachelor's, Master's, MBA, Certificate
    let duration: Int? // in months
    let enrollmentCount: Int?
    let courses: [ProgramCourse]?
    let progress: ProgramProgress?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, domain
        case degreeType = "degree_type"
        case duration
        case enrollmentCount = "enrollment_count"
        case courses, progress
    }
}

struct ProgramCourse: Codable, Identifiable {
    let id: String
    let courseId: String
    let title: String
    let isRequired: Bool
    let order: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course_id"
        case title
        case isRequired = "is_required"
        case order
    }
}

struct ProgramProgress: Codable {
    let completionPercentage: Double
    let coursesCompleted: Int
    let totalCourses: Int
    
    enum CodingKeys: String, CodingKey {
        case completionPercentage = "completion_percentage"
        case coursesCompleted = "courses_completed"
        case totalCourses = "total_courses"
    }
}
