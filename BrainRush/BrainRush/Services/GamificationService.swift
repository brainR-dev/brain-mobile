//
//  GamificationService.swift
//  BrainRush
//
//  Gamification service
//

import Foundation

@MainActor
class GamificationService: ObservableObject {
    static let shared = GamificationService()
    
    @Published var userXP: UserXP?
    @Published var achievements: [Achievement] = []
    @Published var activeChallenges: [Challenge] = []
    @Published var leaderboards: [String: Leaderboard] = [:]
    @Published var isLoading = false
    
    private init() {}
    
    func loadUserXP() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let xp: UserXP = try await APIClient.shared.request(
                endpoint: "/mobile/xp",
                method: "GET",
                accessToken: token
            )
            self.userXP = xp
        } catch {
            // Handle error
        }
    }
    
    func loadAchievements() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let achievements: [Achievement] = try await APIClient.shared.request(
                endpoint: "/mobile/achievements",
                method: "GET",
                accessToken: token
            )
            self.achievements = achievements
        } catch {
            // Handle error
        }
    }
    
    func loadChallenges() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let challenges: [Challenge] = try await APIClient.shared.request(
                endpoint: "/mobile/challenges",
                method: "GET",
                accessToken: token
            )
            self.activeChallenges = challenges
        } catch {
            // Handle error
        }
    }
    
    func loadLeaderboard(type: String, timeframe: String = "all-time") async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let leaderboard: Leaderboard = try await APIClient.shared.request(
                endpoint: "/mobile/leaderboards?type=\(type)&timeframe=\(timeframe)",
                method: "GET",
                accessToken: token
            )
            self.leaderboards["\(type)_\(timeframe)"] = leaderboard
        } catch {
            // Handle error
        }
    }
}
