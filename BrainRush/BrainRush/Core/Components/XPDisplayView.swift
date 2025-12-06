//
//  XPDisplayView.swift
//  BrainRush
//
//  XP display component with animations
//

import SwiftUI

struct XPDisplayView: View {
    let xp: UserXP
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Level \(xp.level)")
                    .font(.headline)
                
                Spacer()
                
                Text("\(xp.currentXP) / \(xp.currentXP + xp.xpToNextLevel) XP")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                        .frame(height: 20)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * animatedProgress, height: 20)
                        .animation(.spring(response: 0.6), value: animatedProgress)
                }
            }
            .frame(height: 20)
            
            HStack {
                Text("\(xp.xpToNextLevel) XP to next level")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onAppear {
            animatedProgress = Double(xp.currentXP) / Double(xp.currentXP + xp.xpToNextLevel)
        }
        .onChange(of: xp.currentXP) { _ in
            withAnimation {
                animatedProgress = Double(xp.currentXP) / Double(xp.currentXP + xp.xpToNextLevel)
            }
        }
    }
}

#Preview {
    XPDisplayView(xp: UserXP(
        currentXP: 750,
        level: 12,
        xpToNextLevel: 250,
        lifetimeXP: 5000
    ))
}
