//
//  ProfileSettingsView.swift
//  BrainRush
//
//  Profile and settings view
//

import SwiftUI

struct ProfileSettingsView: View {
    @StateObject private var authService = AuthService.shared
    @State private var showEditProfile = false
    
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
                            Text("Level 1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Account") {
                    NavigationLink("Edit Profile") {
                        EditProfileView()
                    }
                    
                    NavigationLink("Change Password") {
                        ChangePasswordView()
                    }
                    
                    NavigationLink("Email Settings") {
                        EmailSettingsView()
                    }
                }
                
                Section("Preferences") {
                    NavigationLink("Notification Settings") {
                        NotificationSettingsView()
                    }
                    
                    NavigationLink("Learning Preferences") {
                        LearningPreferencesView()
                    }
                    
                    NavigationLink("Appearance") {
                        AppearanceSettingsView()
                    }
                }
                
                Section("Data") {
                    Button("Export Data") {
                        AnalyticsService.shared.track("data_export_requested")
                        // Export data
                    }
                    
                    Button("Delete Account", role: .destructive) {
                        AnalyticsService.shared.track("delete_account_requested")
                        // Delete account
                    }
                }
                
                Section {
                    Button("Sign Out", role: .destructive) {
                        AnalyticsService.shared.track("sign_out_button_tapped")
                        Task {
                            try? await authService.signOut()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .task {
                AnalyticsService.shared.trackScreen("profile_settings")
            }
        }
    }
}

struct EditProfileView: View {
    @State private var name = ""
    @State private var bio = ""
    
    var body: some View {
        Form {
            Section("Profile Information") {
                TextField("Name", text: $name)
                TextField("Bio", text: $bio, axis: .vertical)
                    .lineLimit(3...6)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    AnalyticsService.shared.track("profile_updated", properties: [
                        "has_name": !name.isEmpty,
                        "has_bio": !bio.isEmpty
                    ])
                    // Save profile
                }
            }
        }
        .task {
            AnalyticsService.shared.trackScreen("edit_profile")
        }
    }
}

struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        Form {
            Section {
                SecureField("Current Password", text: $currentPassword)
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmPassword)
            }
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    AnalyticsService.shared.track("password_change_requested")
                    // Change password
                }
            }
        }
        .task {
            AnalyticsService.shared.trackScreen("change_password")
        }
    }
}

struct EmailSettingsView: View {
    @State private var courseUpdates = true
    @State private var achievements = true
    @State private var challenges = true
    
    var body: some View {
        Form {
            Section("Email Notifications") {
                Toggle("Course Updates", isOn: $courseUpdates)
                    .onChange(of: courseUpdates) { newValue in
                        AnalyticsService.shared.track("email_setting_changed", properties: [
                            "setting": "course_updates",
                            "enabled": newValue
                        ])
                    }
                
                Toggle("Achievement Notifications", isOn: $achievements)
                    .onChange(of: achievements) { newValue in
                        AnalyticsService.shared.track("email_setting_changed", properties: [
                            "setting": "achievements",
                            "enabled": newValue
                        ])
                    }
                
                Toggle("Challenge Reminders", isOn: $challenges)
                    .onChange(of: challenges) { newValue in
                        AnalyticsService.shared.track("email_setting_changed", properties: [
                            "setting": "challenges",
                            "enabled": newValue
                        ])
                    }
            }
        }
        .navigationTitle("Email Settings")
        .task {
            AnalyticsService.shared.trackScreen("email_settings")
        }
    }
}

struct NotificationSettingsView: View {
    @State private var enableNotifications = true
    @State private var levelUp = true
    @State private var achievementAlerts = true
    @State private var challengeReminders = true
    @State private var messages = true
    
    var body: some View {
        Form {
            Section("Push Notifications") {
                Toggle("Enable Notifications", isOn: $enableNotifications)
                    .onChange(of: enableNotifications) { newValue in
                        AnalyticsService.shared.track("push_notification_setting_changed", properties: [
                            "setting": "enable_notifications",
                            "enabled": newValue
                        ])
                    }
                
                Toggle("Level Up", isOn: $levelUp)
                    .onChange(of: levelUp) { newValue in
                        AnalyticsService.shared.track("push_notification_setting_changed", properties: [
                            "setting": "level_up",
                            "enabled": newValue
                        ])
                    }
                
                Toggle("Achievements", isOn: $achievementAlerts)
                    .onChange(of: achievementAlerts) { newValue in
                        AnalyticsService.shared.track("push_notification_setting_changed", properties: [
                            "setting": "achievements",
                            "enabled": newValue
                        ])
                    }
                
                Toggle("Challenges", isOn: $challengeReminders)
                    .onChange(of: challengeReminders) { newValue in
                        AnalyticsService.shared.track("push_notification_setting_changed", properties: [
                            "setting": "challenges",
                            "enabled": newValue
                        ])
                    }
                
                Toggle("Messages", isOn: $messages)
                    .onChange(of: messages) { newValue in
                        AnalyticsService.shared.track("push_notification_setting_changed", properties: [
                            "setting": "messages",
                            "enabled": newValue
                        ])
                    }
            }
            
            Section("Quiet Hours") {
                DatePicker("Start", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                DatePicker("End", selection: .constant(Date()), displayedComponents: .hourAndMinute)
            }
        }
        .navigationTitle("Notifications")
        .task {
            AnalyticsService.shared.trackScreen("notification_settings")
        }
    }
}

struct LearningPreferencesView: View {
    @State private var defaultPlaybackSpeed = 1.0
    @State private var autoplayEnabled = true
    
    var body: some View {
        Form {
            Section("Video") {
                VStack {
                    Text("Default Playback Speed: \(defaultPlaybackSpeed, specifier: "%.1f")x")
                    Slider(value: $defaultPlaybackSpeed, in: 0.5...2.0, step: 0.25)
                        .onChange(of: defaultPlaybackSpeed) { newValue in
                            AnalyticsService.shared.track("learning_preference_changed", properties: [
                                "preference": "playback_speed",
                                "value": newValue
                            ])
                        }
                }
                
                Toggle("Autoplay Next Lesson", isOn: $autoplayEnabled)
                    .onChange(of: autoplayEnabled) { newValue in
                        AnalyticsService.shared.track("learning_preference_changed", properties: [
                            "preference": "autoplay",
                            "enabled": newValue
                        ])
                    }
            }
            
            Section("Downloads") {
                Picker("Video Quality", selection: .constant("HD")) {
                    Text("SD").tag("SD")
                    Text("HD").tag("HD")
                    Text("Full HD").tag("Full HD")
                }
                .onChange(of: "HD") { _ in
                    AnalyticsService.shared.track("learning_preference_changed", properties: [
                        "preference": "video_quality",
                        "value": "HD"
                    ])
                }
            }
        }
        .navigationTitle("Learning Preferences")
        .task {
            AnalyticsService.shared.trackScreen("learning_preferences")
        }
    }
}

struct AppearanceSettingsView: View {
    @AppStorage("darkModeEnabled") private var darkMode = false
    
    var body: some View {
        Form {
            Section("Theme") {
                Toggle("Dark Mode", isOn: $darkMode)
                    .onChange(of: darkMode) { newValue in
                        AnalyticsService.shared.track("appearance_setting_changed", properties: [
                            "setting": "dark_mode",
                            "enabled": newValue
                        ])
                    }
            }
            
            Section("Display") {
                Picker("Font Size", selection: .constant("Medium")) {
                    Text("Small").tag("Small")
                    Text("Medium").tag("Medium")
                    Text("Large").tag("Large")
                }
                .onChange(of: "Medium") { _ in
                    AnalyticsService.shared.track("appearance_setting_changed", properties: [
                        "setting": "font_size",
                        "value": "Medium"
                    ])
                }
            }
        }
        .navigationTitle("Appearance")
        .task {
            AnalyticsService.shared.trackScreen("appearance_settings")
        }
    }
}

#Preview {
    ProfileSettingsView()
}
