//
//  Quiz.swift
//  BrainRush
//
//  Quiz models
//

import Foundation

struct Quiz: Codable, Identifiable {
    let id: String
    let courseId: String
    let lessonId: String?
    let title: String
    let description: String?
    let questions: [QuizQuestion]
    let timeLimit: Int? // in minutes
    let passingScore: Double? // 0.0 to 1.0
    let isTimed: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case courseId = "course_id"
        case lessonId = "lesson_id"
        case title, description, questions
        case timeLimit = "time_limit"
        case passingScore = "passing_score"
        case isTimed = "is_timed"
    }
}

struct QuizQuestion: Codable, Identifiable {
    let id: String
    let type: String // multiple_choice, true_false, fill_blank, short_answer, essay, coding, etc.
    let question: String
    let options: [String]? // For multiple choice
    let correctAnswer: String?
    let correctAnswers: [String]? // For multiple correct answers
    let explanation: String?
    let points: Int
    
    enum CodingKeys: String, CodingKey {
        case id, type, question, options
        case correctAnswer = "correct_answer"
        case correctAnswers = "correct_answers"
        case explanation, points
    }
}

struct QuizResult: Codable {
    let quizId: String
    let score: Double // 0.0 to 1.0
    let totalPoints: Int
    let earnedPoints: Int
    let passed: Bool
    let answers: [QuestionAnswer]
    let completedAt: String
    
    enum CodingKeys: String, CodingKey {
        case quizId = "quiz_id"
        case score
        case totalPoints = "total_points"
        case earnedPoints = "earned_points"
        case passed
        case answers
        case completedAt = "completed_at"
    }
}

struct QuestionAnswer: Codable {
    let questionId: String
    let answer: String
    let isCorrect: Bool
    
    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case answer
        case isCorrect = "is_correct"
    }
}
