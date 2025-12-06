//
//  LevelUpCelebrationView.swift
//  BrainRush
//
//  Level up celebration animation
//

import SwiftUI

struct LevelUpCelebrationView: View {
    let newLevel: Int
    let onDismiss: () -> Void
    @State private var showConfetti = false
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Confetti effect
                if showConfetti {
                    ForEach(0..<50, id: \.self) { _ in
                        ConfettiParticle()
                    }
                }
                
                // Level up content
                VStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow, .orange],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(showConfetti ? 360 : 0))
                        .animation(.spring(response: 0.6), value: scale)
                    
                    Text("Level Up!")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("You reached Level \(newLevel)!")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Button("Awesome!") {
                        onDismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.top, 8)
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.9), Color.purple.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .shadow(radius: 20)
            }
        }
        .onAppear {
            withAnimation {
                scale = 1.0
                showConfetti = true
            }
        }
    }
}

struct ConfettiParticle: View {
    @State private var offset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple]
    
    var body: some View {
        Circle()
            .fill(colors.randomElement() ?? .blue)
            .frame(width: 8, height: 8)
            .offset(offset)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 2)) {
                    offset = CGSize(
                        width: CGFloat.random(in: -200...200),
                        height: CGFloat.random(in: -300...0)
                    )
                    rotation = Double.random(in: 0...720)
                    opacity = 0
                }
            }
    }
}

#Preview {
    LevelUpCelebrationView(newLevel: 13, onDismiss: {})
}
