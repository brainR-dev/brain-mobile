//
//  AchievementsView.swift
//  BrainRush
//
//  Achievements gallery view
//

import SwiftUI

struct AchievementsView: View {
    @StateObject private var gamificationService = GamificationService.shared
    @State private var selectedCategory: String?
    @State private var selectedRarity: String?
    
    var filteredAchievements: [Achievement] {
        var achievements = gamificationService.achievements
        
        if let category = selectedCategory {
            achievements = achievements.filter { $0.category == category }
        }
        
        if let rarity = selectedRarity {
            achievements = achievements.filter { $0.rarity == rarity }
        }
        
        return achievements
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        FilterChip(title: "Getting Started", isSelected: selectedCategory == "getting_started") {
                            selectedCategory = "getting_started"
                        }
                        FilterChip(title: "Learning", isSelected: selectedCategory == "learning_progress") {
                            selectedCategory = "learning_progress"
                        }
                        FilterChip(title: "Social", isSelected: selectedCategory == "social_brain") {
                            selectedCategory = "social_brain"
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Achievements Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                        ForEach(filteredAchievements) { achievement in
                            AchievementCard(achievement: achievement)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Achievements")
            .task {
                await gamificationService.loadAchievements()
            }
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    init(achievement: Achievement) {
        self.achievement = achievement
        self.isUnlocked = achievement.isUnlocked ?? false
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Achievement Icon
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked == true ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                if isUnlocked {
                    Image(systemName: achievement.icon ?? "trophy.fill")
                        .font(.system(size: 50))
                        .foregroundColor(rarityColor)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                }
            }
            
            Text(achievement.name)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            if let progress = achievement.progress, !isUnlocked {
                ProgressView(value: progress)
                    .tint(.blue)
                
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            // Rarity badge
            Text(achievement.rarity)
                .font(.caption2)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(rarityColor.opacity(0.2))
                .foregroundColor(rarityColor)
                .cornerRadius(4)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .opacity(isUnlocked ? 1.0 : 0.6)
    }
    
    private var rarityColor: Color {
        switch achievement.rarity {
        case "Common": return .gray
        case "Uncommon": return .green
        case "Rare": return .blue
        case "Epic": return .purple
        case "Legendary": return .orange
        default: return .gray
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

#Preview {
    AchievementsView()
}
