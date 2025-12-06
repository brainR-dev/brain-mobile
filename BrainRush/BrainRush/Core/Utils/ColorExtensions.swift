//
//  ColorExtensions.swift
//  BrainRush
//
//  Color utilities for game-like UI
//

import SwiftUI

extension Color {
    // Gamification Colors
    static let xpBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let xpPurple = Color(red: 0.6, green: 0.2, blue: 1.0)
    
    // Rarity Colors
    static let commonGray = Color.gray
    static let uncommonGreen = Color.green
    static let rareBlue = Color.blue
    static let epicPurple = Color.purple
    static let legendaryOrange = Color.orange
    
    // Status Colors
    static let successGreen = Color.green
    static let warningOrange = Color.orange
    static let errorRed = Color.red
    
    // Brain Domain Colors
    static let analyticalBlue = Color.blue
    static let creativePurple = Color.purple
    static let practicalGreen = Color.green
    static let theoreticalIndigo = Color.indigo
    static let intuitivePink = Color.pink
    static let structuredGray = Color.gray
}
