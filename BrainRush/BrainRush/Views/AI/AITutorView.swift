//
//  AITutorView.swift
//  BrainRush
//
//  AI Tutor chat view
//

import SwiftUI

struct AITutorView: View {
    @StateObject private var aiService = AITutorService.shared
    @State private var selectedPersona: AITutorPersona?
    @State private var messageText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Persona Selector
                if !aiService.personas.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(aiService.personas) { persona in
                                PersonaChip(persona: persona, isSelected: selectedPersona?.id == persona.id) {
                                    selectedPersona = persona
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                // Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(aiService.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: aiService.messages.count) { _ in
                        if let lastMessage = aiService.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Quota Display
                if let quota = aiService.quota {
                    HStack {
                        Text("Questions remaining: \(quota.remaining)/\(quota.limit)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                }
                
                // Input
                HStack(spacing: 12) {
                    TextField("Ask a question...", text: $messageText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...4)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(messageText.isEmpty ? .gray : .blue)
                    }
                    .disabled(messageText.isEmpty || aiService.isLoading)
                }
                .padding()
            }
            .navigationTitle("AI Tutor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        aiService.clearMessages()
                    }
                }
            }
            .task {
                AnalyticsService.shared.trackScreen("ai_tutor")
                await aiService.loadPersonas()
                if selectedPersona == nil, let firstPersona = aiService.personas.first {
                    selectedPersona = firstPersona
                }
                await aiService.loadMessages()
                await aiService.loadQuota()
            }
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty, let persona = selectedPersona else { return }
        Task {
            await aiService.sendMessage(content: messageText, personaId: persona.id)
            messageText = ""
        }
    }
}

struct PersonaChip: View {
    let persona: AITutorPersona
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(persona.name)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                Text(persona.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
            .foregroundColor(isSelected ? .blue : .primary)
            .cornerRadius(12)
        }
    }
}

struct MessageBubble: View {
    let message: AITutorMessage
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
            }
            
            VStack(alignment: message.role == "user" ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding()
                    .background(message.role == "user" ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.role == "user" ? .white : .primary)
                    .cornerRadius(16)
            }
            
            if message.role == "assistant" {
                Spacer()
            }
        }
    }
}

@MainActor
class AITutorService: ObservableObject {
    static let shared = AITutorService()
    
    @Published var personas: [AITutorPersona] = []
    @Published var messages: [AITutorMessage] = []
    @Published var quota: AITutorQuota?
    @Published var isLoading = false
    
    func loadPersonas() async {
        // Load personas
        personas = [
            AITutorPersona(id: "1", name: "Tutor", description: "Educational & thorough", icon: nil),
            AITutorPersona(id: "2", name: "Mentor", description: "Career-focused", icon: nil),
            AITutorPersona(id: "3", name: "Motivator", description: "Encouraging", icon: nil),
            AITutorPersona(id: "4", name: "ELI5", description: "Simple explanations", icon: nil),
            AITutorPersona(id: "5", name: "Challenger", description: "Thought-provoking", icon: nil),
            AITutorPersona(id: "6", name: "Study Buddy", description: "Casual & relatable", icon: nil)
        ]
    }
    
    func sendMessage(content: String, personaId: String) async {
        isLoading = true
        defer { isLoading = false }
        
        // Add user message
        let userMessage = AITutorMessage(
            id: UUID().uuidString,
            role: "user",
            content: content,
            createdAt: Date().ISO8601Format(),
            personaId: personaId
        )
        messages.append(userMessage)
        
        // Send to API
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let response: AITutorMessage = try await APIClient.shared.request(
                endpoint: "/mobile/ai/tutor",
                method: "POST",
                accessToken: token,
                body: ["message": content, "persona_id": personaId]
            )
            messages.append(response)
            
            // Track AI message
            AnalyticsService.shared.trackAITutorMessage(
                personaId: personaId,
                messageLength: content.count
            )
            
            await loadQuota()
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "send_ai_message",
                "persona_id": personaId
            ])
        }
    }
    
    func loadMessages() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let messages: [AITutorMessage] = try await APIClient.shared.request(
                endpoint: "/mobile/ai/tutor/history",
                method: "GET",
                accessToken: token
            )
            self.messages = messages
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_ai_messages"
            ])
        }
    }
    
    func loadQuota() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let quota: AITutorQuota = try await APIClient.shared.request(
                endpoint: "/mobile/ai/tutor/quota",
                method: "GET",
                accessToken: token
            )
            self.quota = quota
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_ai_quota"
            ])
        }
    }
    
    func clearMessages() {
        AnalyticsService.shared.track("ai_tutor_messages_cleared")
        messages = []
    }
}

#Preview {
    AITutorView()
}
