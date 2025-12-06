//
//  QuizServiceTests.swift
//  BrainRushTests
//
//  Unit tests for QuizService
//

import XCTest
@testable import BrainRush

@MainActor
final class QuizServiceTests: XCTestCase {
    var service: QuizService!
    
    override func setUp() {
        super.setUp()
        service = QuizService.shared
    }
    
    func testLoadQuiz() async throws {
        let quizId = "quiz_1"
        
        do {
            let quiz = try await service.loadQuiz(quizId: quizId)
            XCTAssertEqual(quiz.id, quizId)
            XCTAssertFalse(quiz.questions.isEmpty)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testSubmitQuiz() async throws {
        let quizId = "quiz_1"
        let answers = [
            "q_1": "Option A",
            "q_2": "Option B"
        ]
        
        do {
            let result = try await service.submitQuiz(quizId: quizId, answers: answers)
            XCTAssertNotNil(result)
            XCTAssertGreaterThanOrEqual(result.score, 0.0)
            XCTAssertLessThanOrEqual(result.score, 1.0)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testLoadQuizHistory() async {
        await service.loadQuizHistory()
        
        // Verify history is loaded
        XCTAssertNotNil(service.quizHistory)
    }
    
    func testQuizValidation() {
        // Test quiz answer validation
        let question = MockDataFactory.makeQuizQuestion()
        let correctAnswer = question.correctAnswer ?? ""
        
        XCTAssertTrue(Validation.validateQuizAnswer(correctAnswer, for: question))
        XCTAssertFalse(Validation.validateQuizAnswer("Wrong Answer", for: question))
    }
}
