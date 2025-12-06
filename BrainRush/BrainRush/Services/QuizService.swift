//
//  QuizService.swift
//  BrainRush
//
//  Quiz service
//

import Foundation

@MainActor
class QuizService: ObservableObject {
    static let shared = QuizService()
    
    @Published var quizzes: [Quiz] = []
    @Published var quizHistory: [QuizResult] = []
    @Published var isLoading = false
    
    private init() {}
    
    func loadQuiz(quizId: String) async throws -> Quiz {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        do {
            let quiz: Quiz = try await APIClient.shared.request(
                endpoint: "/mobile/quizzes/\(quizId)",
                method: "GET",
                accessToken: token
            )
            
            // Track quiz started
            AnalyticsService.shared.trackQuizStarted(
                quizId: quizId,
                quizTitle: quiz.title
            )
            
            return quiz
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_quiz",
                "quiz_id": quizId
            ])
            throw error
        }
    }
    
    func submitQuiz(quizId: String, answers: [String: String]) async throws -> QuizResult {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        do {
            let result: QuizResult = try await APIClient.shared.request(
                endpoint: "/mobile/quizzes/\(quizId)/submit",
                method: "POST",
                accessToken: token,
                body: ["answers": answers]
            )
            
            // Track quiz completion
            if let quiz = quizzes.first(where: { $0.id == quizId }) {
                AnalyticsService.shared.trackQuizCompleted(
                    quizId: quizId,
                    quizTitle: quiz.title,
                    score: result.score,
                    passed: result.passed
                )
            }
            
            return result
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "submit_quiz",
                "quiz_id": quizId
            ])
            throw error
        }
    }
    
    func loadQuizResults(quizId: String) async throws -> QuizResult {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let result: QuizResult = try await APIClient.shared.request(
            endpoint: "/mobile/quizzes/\(quizId)/results",
            method: "GET",
            accessToken: token
        )
        return result
    }
    
    func loadQuizHistory() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let history: [QuizResult] = try await APIClient.shared.request(
                endpoint: "/mobile/quizzes",
                method: "GET",
                accessToken: token
            )
            self.quizHistory = history
        } catch {
            // Handle error
        }
    }
}
