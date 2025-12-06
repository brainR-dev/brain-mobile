//
//  UserProfile.swift
//  BrainRush
//
//  User profile model
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: String
    var email: String?
    var name: String?
    var avatar: String?
    var createdAt: Date
    var updatedAt: Date
    
    // Onboarding
    var hasCompletedOnboarding: Bool
    var hasCompletedBrainProfile: Bool
    var selectedGoal: String?
    
    init(
        id: String,
        email: String? = nil,
        name: String? = nil,
        avatar: String? = nil,
        hasCompletedOnboarding: Bool = false,
        hasCompletedBrainProfile: Bool = false,
        selectedGoal: String? = nil
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.avatar = avatar
        self.createdAt = Date()
        self.updatedAt = Date()
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.hasCompletedBrainProfile = hasCompletedBrainProfile
        self.selectedGoal = selectedGoal
    }
}
