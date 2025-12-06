//
//  QuizTests.swift
//  BrainRushTests
//
//  Unit tests for Quiz models
//

import XCTest
@testable import BrainRush

final class QuizTests: XCTestCase {
    
    func testQuizDecoding() throws {
        let json = """
        {
            "id": "quiz_1",
            "course_id": "course_1",
            "title": "Test Quiz",
            "description": "Quiz description",
            "questions": [
                {
                    "id": "q_1",
                    "type": "multiple_choice",
                    "question": "What is Swift?",
                    "options": ["Language", "Framework", "Library", "Tool"],
                    "correct_answer": "Language",
                    "explanation": "Swift is a programming language",
                    "points": 10
                }
            ],
            "time_limit": 30,
            "passing_score": 0.7,
            "is_timed": true
        }
        """
        
        let quiz = try TestHelpers.decodeJSON(json, as: Quiz.self)
        
        XCTAssertEqual(quiz.id, "quiz_1")
        XCTAssertEqual(quiz.courseId, "course_1")
        XCTAssertEqual(quiz.title, "Test Quiz")
        XCTAssertEqual(quiz.questions.count, 1)
        XCTAssertEqual(quiz.timeLimit, 30)
        XCTAssertEqual(quiz.passingScore, 0.7)
        XCTAssertTrue(quiz.isTimed)
    }
    
    func testQuizQuestionTypes() {
        let multipleChoice = MockDataFactory.makeQuizQuestion(type: "multiple_choice")
        XCTAssertEqual(multipleChoice.type, "multiple_choice")
        XCTAssertNotNil(multipleChoice.options)
        
        let trueFalse = MockDataFactory.makeQuizQuestion(type: "true_false")
        XCTAssertEqual(trueFalse.type, "true_false")
    }
    
    func testQuizResultDecoding() throws {
        let json = """
        {
            "quiz_id": "quiz_1",
            "score": 0.85,
            "total_points": 100,
            "earned_points": 85,
            "passed": true,
            "answers": [
                {
                    "question_id": "q_1",
                    "answer": "Option A",
                    "is_correct": true
                }
            ],
            "completed_at": "2024-01-01T00:00:00Z"
        }
        """
        
        let result = try TestHelpers.decodeJSON(json, as: QuizResult.self)
        
        XCTAssertEqual(result.quizId, "quiz_1")
        XCTAssertEqual(result.score, 0.85, accuracy: 0.01)
        XCTAssertEqual(result.totalPoints, 100)
        XCTAssertEqual(result.earnedPoints, 85)
        XCTAssertTrue(result.passed)
        XCTAssertEqual(result.answers.count, 1)
    }
}
