//
//  SocialService.swift
//  BrainRush
//
//  Social features service
//

import Foundation

@MainActor
class SocialService: ObservableObject {
    static let shared = SocialService()
    
    @Published var forums: [Forum] = []
    @Published var studyGroups: [StudyGroup] = []
    @Published var conversations: [Conversation] = []
    
    func loadForums() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let forums: [Forum] = try await APIClient.shared.request(
                endpoint: "/mobile/forums",
                method: "GET",
                accessToken: token
            )
            self.forums = forums
        } catch {
            // Handle error
        }
    }
    
    func loadStudyGroups() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let groups: [StudyGroup] = try await APIClient.shared.request(
                endpoint: "/mobile/study-groups",
                method: "GET",
                accessToken: token
            )
            self.studyGroups = groups
        } catch {
            // Handle error
        }
    }
    
    func loadConversations() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let conversations: [Conversation] = try await APIClient.shared.request(
                endpoint: "/mobile/messages",
                method: "GET",
                accessToken: token
            )
            self.conversations = conversations
        } catch {
            // Handle error
        }
    }
}
