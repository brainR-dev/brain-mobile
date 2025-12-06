//
//  RootView.swift
//  BrainRush
//
//  Root view that handles navigation between auth and main app
//

import SwiftUI

struct RootView: View {
    @StateObject private var authService = AuthService.shared
    @State private var showOnboarding = false
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                // Check if user needs onboarding
                if showOnboarding {
                    OnboardingView()
                } else {
                    // Main app view
                    MainTabView()
                }
            } else {
                // Authentication flow
                SignInView()
            }
        }
        .task {
            await authService.checkSession()
            // Check if user needs onboarding (would check from user profile)
            // showOnboarding = !userProfile.hasCompletedOnboarding
        }
    }
}

// Main app view
struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            CoursesView()
                .tabItem {
                    Label("Courses", systemImage: "book.fill")
                }
            
            AchievementsView()
                .tabItem {
                    Label("Achievements", systemImage: "trophy.fill")
                }
            
            ChallengesView()
                .tabItem {
                    Label("Challenges", systemImage: "target")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

struct ProfileView: View {
    @StateObject private var authService = AuthService.shared
    @StateObject private var gamificationService = GamificationService.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(authService.currentUser?.email ?? "User")
                                .font(.headline)
                            if let xp = gamificationService.userXP {
                                Text("Level \(xp.level) • \(xp.currentXP) XP")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Quick Access") {
                    NavigationLink("Achievements") {
                        AchievementsView()
                    }
                    
                    NavigationLink("Certificates") {
                        CertificatesView()
                    }
                    
                    NavigationLink("Wallet") {
                        TokenWalletView()
                    }
                    
                    NavigationLink("Swag Store") {
                        SwagStoreView()
                    }
                }
                
                Section("Social") {
                    NavigationLink("Forums") {
                        ForumsView()
                    }
                    
                    NavigationLink("Study Groups") {
                        StudyGroupsView()
                    }
                    
                    NavigationLink("Messages") {
                        MessagingView()
                    }
                }
                
                Section("AI") {
                    NavigationLink("AI Tutor") {
                        AITutorView()
                    }
                    
                    NavigationLink("Study Planner") {
                        AIStudyPlannerView()
                    }
                }
                
                Section("Learning") {
                    NavigationLink("Brain Profile") {
                        BrainProfileView()
                    }
                    
                    NavigationLink("Leaderboard") {
                        LeaderboardView()
                    }
                }
                
                Section("Settings") {
                    NavigationLink("Profile Settings") {
                        ProfileSettingsView()
                    }
                }
                
                Section {
                    Button(action: {
                        Task {
                            try? await authService.signOut()
                        }
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .task {
                await gamificationService.loadUserXP()
            }
        }
    }
}

#Preview {
    RootView()
}
