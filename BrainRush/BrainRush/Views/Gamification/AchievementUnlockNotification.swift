//
//  AchievementUnlockNotification.swift
//  BrainRush
//
//  Achievement unlock notification overlay
//

import SwiftUI

struct AchievementUnlockNotification: View {
    let achievement: Achievement
    let onDismiss: () -> Void
    @State private var offset: CGFloat = -200
    @State private var opacity: Double = 0
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(rarityColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon ?? "trophy.fill")
                    .font(.title2)
                    .foregroundColor(rarityColor)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text("Achievement Unlocked!")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(achievement.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
        .offset(y: offset)
        .opacity(opacity)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                offset = 0
                opacity = 1
            }
            
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                dismiss()
            }
        }
    }
    
    private func dismiss() {
        withAnimation {
            offset = -200
            opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
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

#Preview {
    ZStack {
        Color.gray
        AchievementUnlockNotification(
            achievement: Achievement(
                id: "1",
                name: "First Steps",
                description: "Complete your first lesson",
                category: "getting_started",
                rarity: "Rare",
                icon: "trophy.fill",
                points: 10,
                isUnlocked: true,
                progress: nil,
                unlockedAt: nil
            ),
            onDismiss: {}
        )
    }
}
