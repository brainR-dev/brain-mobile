//
//  AchievementUnlockView.swift
//  BrainRush
//
//  Achievement unlock animation
//

import SwiftUI

struct AchievementUnlockView: View {
    let achievement: Achievement
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0.5
    @State private var rotation: Double = -180
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(rarityColor.opacity(0.3))
                        .frame(width: 200, height: 200)
                    
                    Image(systemName: achievement.icon ?? "trophy.fill")
                        .font(.system(size: 100))
                        .foregroundColor(rarityColor)
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(rotation))
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.6), value: scale)
                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: rotation)
                
                VStack(spacing: 12) {
                    Text("Achievement Unlocked!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(achievement.name)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(achievement.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text(achievement.rarity)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(rarityColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button("Awesome!") {
                    onDismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [rarityColor.opacity(0.9), rarityColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .shadow(radius: 20)
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                rotation = 0
            }
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
    AchievementUnlockView(
        achievement: Achievement(
            id: "1",
            name: "First Steps",
            description: "Complete your first lesson",
            category: "getting_started",
            rarity: "Common",
            icon: "trophy.fill",
            points: 10,
            isUnlocked: true,
            progress: nil,
            unlockedAt: nil
        ),
        onDismiss: {}
    )
}
