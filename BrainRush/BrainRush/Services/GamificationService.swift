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
            
            // Track level up if level increased
            if let previousXP = self.userXP, previousXP.level < xp.level {
                AnalyticsService.shared.trackLevelUp(newLevel: xp.level, xp: xp.currentXP)
                
                // Update user properties in analytics
                AnalyticsService.shared.setUserProperties([
                    "level": xp.level,
                    "xp": xp.currentXP,
                    "lifetime_xp": xp.lifetimeXP
                ])
            } else if self.userXP == nil {
                // First load - set initial user properties
                AnalyticsService.shared.setUserProperties([
                    "level": xp.level,
                    "xp": xp.currentXP,
                    "lifetime_xp": xp.lifetimeXP
                ])
            }
            
            self.userXP = xp
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_user_xp"
            ])
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
            
            // Track newly unlocked achievements
            let previousUnlockedIds = Set(self.achievements.filter { $0.isUnlocked == true }.map { $0.id })
            let newUnlocked = achievements.filter { achievement in
                achievement.isUnlocked == true && !previousUnlockedIds.contains(achievement.id)
            }
            
            for achievement in newUnlocked {
                AnalyticsService.shared.trackAchievementUnlocked(
                    achievementId: achievement.id,
                    achievementName: achievement.name,
                    rarity: achievement.rarity
                )
            }
            
            self.achievements = achievements
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_achievements"
            ])
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
