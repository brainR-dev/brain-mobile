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
            // Handle error
        }
    }
    
    func submitAssessment(answers: [Int: Int]) async throws -> BrainProfile {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let profile: BrainProfile = try await APIClient.shared.request(
            endpoint: "/mobile/brain-profile/create",
            method: "POST",
            accessToken: token,
            body: ["answers": answers]
        )
        self.brainProfile = profile
        return profile
    }
}
