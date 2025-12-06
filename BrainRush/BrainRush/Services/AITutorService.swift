//
//  AITutorService.swift
//  BrainRush
//
//  AI Tutor service
//

import Foundation

@MainActor
class AITutorService: ObservableObject {
    static let shared = AITutorService()
    
    @Published var personas: [AITutorPersona] = []
    @Published var messages: [AITutorMessage] = []
    @Published var quota: AITutorQuota?
    @Published var isLoading = false
    
    private init() {}
    
    func loadPersonas() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let personas: [AITutorPersona] = try await APIClient.shared.request(
                endpoint: "/mobile/ai/tutor/personas",
                method: "GET",
                accessToken: token
            )
            self.personas = personas
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_ai_personas"
            ])
        }
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
