//
//  LessonService.swift
//  BrainRush
//
//  Lesson service
//

import Foundation

@MainActor
class LessonService: ObservableObject {
    static let shared = LessonService()
    
    @Published var isLoading = false
    
    private init() {}
    
    func loadLesson(lessonId: String) async throws -> Lesson {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let lesson: Lesson = try await APIClient.shared.request(
            endpoint: "/mobile/lessons/\(lessonId)",
            method: "GET",
            accessToken: token
        )
        return lesson
    }
    
    func markLessonComplete(lessonId: String) async throws {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let _: EmptyResponse = try await APIClient.shared.request(
            endpoint: "/mobile/lessons/\(lessonId)/complete",
            method: "POST",
            accessToken: token
        )
    }
    
    func saveNotes(lessonId: String, notes: String) async throws {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let _: EmptyResponse = try await APIClient.shared.request(
            endpoint: "/mobile/lessons/\(lessonId)/notes",
            method: "POST",
            accessToken: token,
            body: ["notes": notes]
        )
    }
}
