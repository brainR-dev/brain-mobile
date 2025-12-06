//
//  StudyGroupsView.swift
//  BrainRush
//
//  Study groups view
//

import SwiftUI

struct StudyGroupsView: View {
    @StateObject private var socialService = SocialService.shared
    @State private var showCreateGroup = false
    
    private var groups: [StudyGroup] {
        socialService.studyGroups
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groups) { group in
                    NavigationLink(destination: StudyGroupDetailView(groupId: group.id)) {
                        StudyGroupRow(group: group)
                    }
                }
            }
            .navigationTitle("Study Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCreateGroup = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateGroup) {
                CreateStudyGroupView()
            }
            .task {
                await loadGroups()
            }
        }
    }
    
    private func loadGroups() async {
        await socialService.loadStudyGroups()
    }
}

struct StudyGroupRow: View {
    let group: StudyGroup
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(group.name)
                    .font(.headline)
                
                Spacer()
                
                if !group.isPublic {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            
            if let description = group.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                Label("\(group.memberCount)/\(group.maxMembers)", systemImage: "person.2.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let courseTitle = group.courseId {
                    Text(courseTitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct StudyGroupDetailView: View {
    let groupId: String
    @State private var group: StudyGroup?
    @State private var members: [UserBasic] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if let group = group {
                    // Group Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text(group.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let description = group.description {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Label("\(group.memberCount) members", systemImage: "person.2.fill")
                            Spacer()
                            if group.isPublic {
                                Text("Public")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.green.opacity(0.2))
                                    .foregroundColor(.green)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Members
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Members")
                            .font(.headline)
                        
                        ForEach(members) { member in
                            HStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(String(member.username.prefix(1)))
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(member.username)
                                        .font(.subheadline)
                                    if let level = member.level {
                                        Text("Level \(level)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    
                    // Actions
                    VStack(spacing: 12) {
                        Button("Open Chat") {
                            // Open group chat
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        
                        Button("Leave Group", role: .destructive) {
                            // Leave group
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Study Group")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadGroup()
            await loadMembers()
        }
    }
    
    private func loadGroup() async {
        // Load group details
    }
    
    private func loadMembers() async {
        // Load group members
    }
}

struct CreateStudyGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var isPublic = true
    @State private var maxMembers = 10
    
    var body: some View {
        NavigationView {
            Form {
                Section("Group Details") {
                    TextField("Group Name", text: $name)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Settings") {
                    Toggle("Public Group", isOn: $isPublic)
                    
                    Stepper("Max Members: \(maxMembers)", value: $maxMembers, in: 3...20)
                }
            }
            .navigationTitle("Create Study Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        // Create group
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    StudyGroupsView()
}
