//
//  ProgressRingView.swift
//  BrainRush
//
//  Circular progress ring component
//

import SwiftUI

struct ProgressRingView: View {
    let progress: Double // 0.0 to 1.0
    let lineWidth: CGFloat
    let size: CGFloat
    let colors: [Color]
    
    @State private var animatedProgress: Double = 0
    
    init(
        progress: Double,
        lineWidth: CGFloat = 12,
        size: CGFloat = 100,
        colors: [Color] = [.blue, .purple]
    ) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.size = size
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(Color(.systemGray5), lineWidth: lineWidth)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    AngularGradient(
                        colors: colors,
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.8, dampingFraction: 0.8), value: animatedProgress)
            
            // Center text
            VStack {
                Text("\(Int(progress * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { newValue in
            withAnimation {
                animatedProgress = newValue
            }
        }
    }
}

#Preview {
    ProgressRingView(progress: 0.75)
}
