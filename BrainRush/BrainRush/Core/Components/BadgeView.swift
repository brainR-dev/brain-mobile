//
//  BadgeView.swift
//  BrainRush
//
//  Reusable badge component
//

import SwiftUI

struct BadgeView: View {
    let text: String
    let color: Color
    let style: BadgeStyle
    
    enum BadgeStyle {
        case filled
        case outlined
        case pill
    }
    
    init(_ text: String, color: Color = .blue, style: BadgeStyle = .filled) {
        self.text = text
        self.color = color
        self.style = style
    }
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, style == .pill ? 12 : 8)
            .padding(.vertical, style == .pill ? 6 : 4)
            .background(style == .outlined ? Color.clear : color.opacity(0.2))
            .foregroundColor(style == .outlined ? color : color)
            .overlay(
                RoundedRectangle(cornerRadius: style == .pill ? 12 : 6)
                    .stroke(style == .outlined ? color : Color.clear, lineWidth: 1)
            )
            .cornerRadius(style == .pill ? 12 : 6)
    }
}

#Preview {
    HStack {
        BadgeView("New", color: .green)
        BadgeView("Popular", color: .blue, style: .outlined)
        BadgeView("Featured", color: .purple, style: .pill)
    }
}
