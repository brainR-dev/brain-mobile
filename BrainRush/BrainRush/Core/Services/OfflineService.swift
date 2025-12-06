//
//  OfflineService.swift
//  BrainRush
//
//  Offline mode service
//

import Foundation

class OfflineService {
    static let shared = OfflineService()
    
    private init() {}
    
    func downloadLesson(lessonId: String) async throws {
        // Download lesson content for offline viewing
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        // Download via API
        let _: Data = try await APIClient.shared.request(
            endpoint: "/mobile/lessons/\(lessonId)/download",
            method: "GET",
            accessToken: token
        )
        
        // Store locally (would use SwiftData/CoreData)
    }
    
    func syncOfflineChanges() async throws {
        // Sync any offline changes when back online
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        // Push offline changes
        let _: EmptyResponse = try await APIClient.shared.request(
            endpoint: "/mobile/sync/push",
            method: "POST",
            accessToken: token,
            body: ["changes": []] // Would include actual offline changes
        )
    }
}
