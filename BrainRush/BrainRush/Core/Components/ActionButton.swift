//
//  ActionButton.swift
//  BrainRush
//
//  Reusable action button with game-like styling
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let style: ButtonStyle
    let isLoading: Bool
    
    enum ButtonStyle {
        case primary
        case secondary
        case danger
        case success
    }
    
    init(
        _ title: String,
        icon: String? = nil,
        style: ButtonStyle = .primary,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(12)
            .shadow(color: backgroundColor.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(isLoading)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return .blue
        case .secondary: return .gray
        case .danger: return .red
        case .success: return .green
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        ActionButton("Primary Button", icon: "star.fill") {}
        ActionButton("Secondary Button", style: .secondary) {}
        ActionButton("Danger Button", style: .danger) {}
        ActionButton("Loading...", isLoading: true) {}
    }
    .padding()
}
