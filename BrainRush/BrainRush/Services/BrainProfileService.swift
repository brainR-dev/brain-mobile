//
//  BrainProfileService.swift
//  BrainRush
//
//  Brain Profile service
//

import Foundation

@MainActor
class BrainProfileService: ObservableObject {
    static let shared = BrainProfileService()
    
    @Published var brainProfile: BrainProfile?
    @Published var isLoading = false
    
    private init() {}
    
    func loadBrainProfile() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let profile: BrainProfile = try await APIClient.shared.request(
                endpoint: "/mobile/brain-profile",
                method: "GET",
                accessToken: token
            )
            self.brainProfile = profile
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_brain_profile"
            ])
        }
    }
    
    func submitAssessment(answers: [Int: Int]) async throws -> BrainProfile {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        do {
            let profile: BrainProfile = try await APIClient.shared.request(
                endpoint: "/mobile/brain-profile/create",
                method: "POST",
                accessToken: token,
                body: ["answers": answers]
            )
            self.brainProfile = profile
            
            // Track assessment completion
            AnalyticsService.shared.track("brain_profile_assessment_completed", properties: [
                "answers_count": answers.count
            ])
            
            return profile
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "submit_brain_profile_assessment"
            ])
            throw error
        }
    }
}
