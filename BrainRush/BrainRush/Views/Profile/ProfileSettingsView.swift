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
                        // Export data
                    }
                    
                    Button("Delete Account", role: .destructive) {
                        // Delete account
                    }
                }
                
                Section {
                    Button("Sign Out", role: .destructive) {
                        Task {
                            try? await authService.signOut()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
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
                    // Save profile
                }
            }
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
                    // Change password
                }
            }
        }
    }
}

struct EmailSettingsView: View {
    var body: some View {
        Form {
            Section("Email Notifications") {
                Toggle("Course Updates", isOn: .constant(true))
                Toggle("Achievement Notifications", isOn: .constant(true))
                Toggle("Challenge Reminders", isOn: .constant(true))
            }
        }
        .navigationTitle("Email Settings")
    }
}

struct NotificationSettingsView: View {
    var body: some View {
        Form {
            Section("Push Notifications") {
                Toggle("Enable Notifications", isOn: .constant(true))
                Toggle("Level Up", isOn: .constant(true))
                Toggle("Achievements", isOn: .constant(true))
                Toggle("Challenges", isOn: .constant(true))
                Toggle("Messages", isOn: .constant(true))
            }
            
            Section("Quiet Hours") {
                DatePicker("Start", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                DatePicker("End", selection: .constant(Date()), displayedComponents: .hourAndMinute)
            }
        }
        .navigationTitle("Notifications")
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
                }
                
                Toggle("Autoplay Next Lesson", isOn: $autoplayEnabled)
            }
            
            Section("Downloads") {
                Picker("Video Quality", selection: .constant("HD")) {
                    Text("SD").tag("SD")
                    Text("HD").tag("HD")
                    Text("Full HD").tag("Full HD")
                }
            }
        }
        .navigationTitle("Learning Preferences")
    }
}

struct AppearanceSettingsView: View {
    @AppStorage("darkModeEnabled") private var darkMode = false
    
    var body: some View {
        Form {
            Section("Theme") {
                Toggle("Dark Mode", isOn: $darkMode)
            }
            
            Section("Display") {
                Picker("Font Size", selection: .constant("Medium")) {
                    Text("Small").tag("Small")
                    Text("Medium").tag("Medium")
                    Text("Large").tag("Large")
                }
            }
        }
        .navigationTitle("Appearance")
    }
}

#Preview {
    ProfileSettingsView()
}
