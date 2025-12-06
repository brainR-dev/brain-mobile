//
//  ChallengesView.swift
//  BrainRush
//
//  Challenges view
//

import SwiftUI

struct ChallengesView: View {
    @StateObject private var gamificationService = GamificationService.shared
    
    var dailyChallenges: [Challenge] {
        gamificationService.activeChallenges.filter { $0.type == "daily" }
    }
    
    var weeklyChallenges: [Challenge] {
        gamificationService.activeChallenges.filter { $0.type == "weekly" }
    }
    
    var monthlyChallenges: [Challenge] {
        gamificationService.activeChallenges.filter { $0.type == "monthly" }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if !dailyChallenges.isEmpty {
                        ChallengeSection(title: "Daily Challenges", challenges: dailyChallenges)
                    }
                    
                    if !weeklyChallenges.isEmpty {
                        ChallengeSection(title: "Weekly Challenges", challenges: weeklyChallenges)
                    }
                    
                    if !monthlyChallenges.isEmpty {
                        ChallengeSection(title: "Monthly Challenges", challenges: monthlyChallenges)
                    }
                }
                .padding()
            }
            .navigationTitle("Challenges")
            .task {
                AnalyticsService.shared.trackScreen("challenges")
                await gamificationService.loadChallenges()
            }
        }
    }
}

struct ChallengeSection: View {
    let title: String
    let challenges: [Challenge]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(challenges) { challenge in
                ChallengeCard(challenge: challenge)
            }
        }
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.name)
                        .font(.headline)
                    Text(challenge.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if challenge.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            // Progress
            VStack(alignment: .leading, spacing: 4) {
                ProgressView(value: challenge.progress)
                    .tint(.blue)
                
                Text("\(challenge.current) / \(challenge.target)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Time remaining
            if !challenge.isCompleted {
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                    Text(timeRemaining)
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            
            // Rewards
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("\(challenge.rewards.xp) XP")
                    .font(.caption)
                
                Image(systemName: "bolt.fill")
                    .foregroundColor(.blue)
                Text("\(challenge.rewards.tokens) Tokens")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var timeRemaining: String {
        // Calculate time remaining until endDate
        return "Ends in 2 days"
    }
}

#Preview {
    ChallengesView()
}
