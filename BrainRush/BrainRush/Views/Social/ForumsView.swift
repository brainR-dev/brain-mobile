//
//  ForumsView.swift
//  BrainRush
//
//  Forums view
//

import SwiftUI

struct ForumsView: View {
    @StateObject private var socialService = SocialService.shared
    @State private var isLoading = false
    
    private var forums: [Forum] {
        socialService.forums
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(forums) { forum in
                    NavigationLink(destination: ForumThreadsView(forumId: forum.id)) {
                        ForumRow(forum: forum)
                    }
                }
            }
            .navigationTitle("Forums")
            .task {
                await loadForums()
            }
        }
    }
    
    private func loadForums() async {
        isLoading = true
        await socialService.loadForums()
        isLoading = false
    }
}

struct ForumRow: View {
    let forum: Forum
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(forum.name)
                .font(.headline)
            
            if let description = forum.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            HStack {
                if let threadCount = forum.threadCount {
                    Label("\(threadCount) threads", systemImage: "message.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct ForumThreadsView: View {
    let forumId: String
    @State private var threads: [ForumThread] = []
    
    var body: some View {
        List {
            ForEach(threads) { thread in
                NavigationLink(destination: ThreadDetailView(threadId: thread.id)) {
                    ThreadRow(thread: thread)
                }
            }
        }
        .navigationTitle("Threads")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            await loadThreads()
        }
    }
    
    private func loadThreads() async {
        // Load threads for forum
    }
}

struct ThreadRow: View {
    let thread: ForumThread
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(thread.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Spacer()
                
                if thread.isPinned {
                    Image(systemName: "pin.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            
            HStack {
                Text(thread.author.username)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label("\(thread.replyCount)", systemImage: "message.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Label("\(thread.upvotes)", systemImage: "arrow.up")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ThreadDetailView: View {
    let threadId: String
    @State private var thread: ForumThread?
    @State private var replies: [ForumReply] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let thread = thread {
                    // Thread content
                    VStack(alignment: .leading, spacing: 12) {
                        Text(thread.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(thread.content)
                            .font(.body)
                        
                        HStack {
                            Text(thread.author.username)
                                .font(.caption)
                            Spacer()
                            Text(formatDate(thread.createdAt))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Replies
                    ForEach(replies) { reply in
                        ReplyCard(reply: reply)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Reply") {
                    // Show reply sheet
                }
            }
        }
        .task {
            await loadThread()
            await loadReplies()
        }
    }
    
    private func loadThread() async {
        // Load thread details
    }
    
    private func loadReplies() async {
        // Load replies
    }
    
    private func formatDate(_ dateString: String) -> String {
        return dateString
    }
}

struct ReplyCard: View {
    let reply: ForumReply
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(reply.content)
                .font(.body)
            
            HStack {
                Text(reply.author.username)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "arrow.up")
                }
                .font(.caption)
                
                Text("\(reply.upvotes)")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    ForumsView()
}
