//
//  APIMockResponses.swift
//  BrainRushTests
//
//  Mock API responses for testing
//

import Foundation
@testable import BrainRush

struct APIMockResponses {
    
    // MARK: - Authentication
    
    static let signInSuccessResponse = """
    {
        "access_token": "mock_access_token_123",
        "refresh_token": "mock_refresh_token_123",
        "expires_in": 3600,
        "user": {
            "id": "user_1",
            "email": "test@example.com",
            "created_at": "2024-01-01T00:00:00Z"
        }
    }
    """
    
    static let signUpSuccessResponse = signInSuccessResponse
    
    static let unauthorizedResponse = """
    {
        "error": "unauthorized",
        "message": "Invalid credentials"
    }
    """
    
    // MARK: - Courses
    
    static let courseListResponse = """
    {
        "courses": [
            {
                "id": "course_1",
                "title": "Introduction to Swift",
                "description": "Learn Swift programming",
                "instructor": "John Doe",
                "duration": 120,
                "rating": 4.5,
                "category": "Programming"
            }
        ]
    }
    """
    
    static let courseDetailResponse = """
    {
        "id": "course_1",
        "title": "Introduction to Swift",
        "description": "Learn Swift programming",
        "instructor": "John Doe",
        "duration": 120,
        "rating": 4.5,
        "category": "Programming",
        "sections": [
            {
                "id": "section_1",
                "title": "Getting Started",
                "order": 1,
                "lessons": [
                    {
                        "id": "lesson_1",
                        "title": "Introduction",
                        "type": "video",
                        "duration": 15,
                        "order": 1
                    }
                ]
            }
        ]
    }
    """
    
    // MARK: - Gamification
    
    static let userXPResponse = """
    {
        "current_xp": 750,
        "level": 12,
        "xp_to_next_level": 250,
        "lifetime_xp": 5000
    }
    """
    
    static let achievementsResponse = """
    {
        "achievements": [
            {
                "id": "ach_1",
                "name": "First Steps",
                "description": "Complete your first lesson",
                "category": "getting_started",
                "rarity": "Rare",
                "points": 10,
                "is_unlocked": true,
                "progress": 1.0
            }
        ]
    }
    """
    
    static let leaderboardResponse = """
    {
        "leaderboard": [
            {
                "user": {
                    "id": "user_1",
                    "username": "top_learner",
                    "level": 20
                },
                "rank": 1,
                "xp": 10000
            }
        ]
    }
    """
    
    // MARK: - Economy
    
    static let tokenBalanceResponse = """
    {
        "balance": 1000,
        "total_earned": 5000,
        "total_spent": 4000
    }
    """
    
    static let swagItemsResponse = """
    {
        "items": [
            {
                "id": "item_1",
                "name": "Cool Hat",
                "category": "hats",
                "rarity": "Rare",
                "price": 500,
                "is_owned": false
            }
        ]
    }
    """
    
    // MARK: - Dashboard
    
    static let dashboardResponse = """
    {
        "continue_learning": {
            "course_id": "course_1",
            "course_title": "Introduction to Swift",
            "lesson_id": "lesson_1",
            "lesson_title": "Getting Started",
            "progress": 0.6
        },
        "quick_stats": {
            "courses_in_progress": 3,
            "courses_completed": 5,
            "current_xp": 750,
            "current_level": 12,
            "study_streak": 7
        }
    }
    """
    
    // MARK: - Quiz
    
    static let quizResponse = """
    {
        "id": "quiz_1",
        "title": "Swift Basics Quiz",
        "questions": [
            {
                "id": "q_1",
                "type": "multiple_choice",
                "question": "What is Swift?",
                "options": ["Language", "Framework", "Library", "Tool"],
                "correct_answer": "Language",
                "points": 10
            }
        ],
        "time_limit": 30,
        "passing_score": 0.7
    }
    """
    
    static let quizResultResponse = """
    {
        "quiz_id": "quiz_1",
        "score": 0.85,
        "total_points": 100,
        "earned_points": 85,
        "passed": true
    }
    """
    
    // MARK: - Error Responses
    
    static let serverErrorResponse = """
    {
        "error": "internal_server_error",
        "message": "An unexpected error occurred"
    }
    """
    
    static let notFoundResponse = """
    {
        "error": "not_found",
        "message": "Resource not found"
    }
    """
    
    static let validationErrorResponse = """
    {
        "error": "validation_error",
        "message": "Invalid input",
        "errors": {
            "email": ["Invalid email format"],
            "password": ["Password too short"]
        }
    }
    """
    
    // MARK: - Helper Methods
    
    static func decode<T: Decodable>(_ jsonString: String, as type: T.Type) throws -> T {
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(type, from: data)
    }
    
    static func getData(_ jsonString: String) -> Data {
        jsonString.data(using: .utf8)!
    }
}
