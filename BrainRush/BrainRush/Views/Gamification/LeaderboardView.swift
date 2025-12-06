//
//  LeaderboardView.swift
//  BrainRush
//
//  Leaderboard view
//

import SwiftUI

struct LeaderboardView: View {
    @StateObject private var gamificationService = GamificationService.shared
    @State private var selectedType = "global"
    @State private var selectedTimeframe = "all-time"
    
    var leaderboard: Leaderboard? {
        gamificationService.leaderboards["\(selectedType)_\(selectedTimeframe)"]
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Type Selector
                Picker("Type", selection: $selectedType) {
                    Text("Global").tag("global")
                    Text("Course").tag("course")
                    Text("Challenge").tag("challenge")
                    Text("Domain").tag("domain")
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Timeframe Selector
                Picker("Timeframe", selection: $selectedTimeframe) {
                    Text("Today").tag("today")
                    Text("Week").tag("week")
                    Text("Month").tag("month")
                    Text("All Time").tag("all-time")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Leaderboard
                if let leaderboard = leaderboard {
                    List {
                        ForEach(leaderboard.entries) { entry in
                            LeaderboardRow(entry: entry, isCurrentUser: entry.id == leaderboard.userEntry?.id)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Leaderboard")
            .task {
                AnalyticsService.shared.trackScreen("leaderboard", properties: [
                    "type": selectedType,
                    "timeframe": selectedTimeframe
                ])
                await gamificationService.loadLeaderboard(type: selectedType, timeframe: selectedTimeframe)
            }
            .onChange(of: selectedType) { _ in
                Task {
                    await gamificationService.loadLeaderboard(type: selectedType, timeframe: selectedTimeframe)
                }
            }
            .onChange(of: selectedTimeframe) { _ in
                Task {
                    await gamificationService.loadLeaderboard(type: selectedType, timeframe: selectedTimeframe)
                }
            }
        }
    }
}

struct LeaderboardRow: View {
    let entry: LeaderboardEntry
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Rank
            Text("#\(entry.rank)")
                .font(.headline)
                .foregroundColor(rankColor)
                .frame(width: 40)
            
            // Avatar
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(entry.username.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            
            // User Info
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.username)
                    .font(.headline)
                Text("Level \(entry.level)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Score
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.score)")
                    .font(.headline)
                Text("XP")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .background(isCurrentUser ? Color.blue.opacity(0.1) : Color.clear)
    }
    
    private var rankColor: Color {
        switch entry.rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .primary
        }
    }
}

#Preview {
    LeaderboardView()
}
