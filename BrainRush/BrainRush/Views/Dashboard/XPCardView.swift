//
//  XPCardView.swift
//  BrainRush
//
//  XP display card for dashboard
//

import SwiftUI

struct XPCardView: View {
    let xp: UserXP
    @State private var showLevelUp = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Level \(xp.level)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(xp.currentXP) XP")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Level badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                    
                    Text("\(xp.level)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 4) {
                ProgressView(value: Double(xp.currentXP), total: Double(xp.currentXP + xp.xpToNextLevel))
                    .tint(.blue)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                HStack {
                    Text("Next level in \(xp.xpToNextLevel) XP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int((Double(xp.currentXP) / Double(xp.currentXP + xp.xpToNextLevel)) * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .sheet(isPresented: $showLevelUp) {
            LevelUpCelebrationView(newLevel: xp.level, onDismiss: { showLevelUp = false })
        }
        .onChange(of: xp.level) { newLevel in
            // Track level up when level changes
            AnalyticsService.shared.trackLevelUp(newLevel: newLevel, xp: xp.currentXP)
            showLevelUp = true
        }
    }
}

#Preview {
    XPCardView(xp: UserXP(
        currentXP: 750,
        level: 12,
        xpToNextLevel: 250,
        lifetimeXP: 5000
    ))
}
