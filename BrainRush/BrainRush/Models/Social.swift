//
//  Social.swift
//  BrainRush
//
//  Social learning models (Forums, Study Groups, Messaging)
//

import Foundation

// MARK: - Forums

struct Forum: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let courseId: String?
    let domain: String?
    let threadCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case courseId = "course_id"
        case domain
        case threadCount = "thread_count"
    }
}

struct ForumThread: Codable, Identifiable {
    let id: String
    let forumId: String
    let title: String
    let content: String
    let author: UserBasic
    let replyCount: Int
    let viewCount: Int
    let upvotes: Int
    let isPinned: Bool
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case forumId = "forum_id"
        case title, content, author
        case replyCount = "reply_count"
        case viewCount = "view_count"
        case upvotes
        case isPinned = "is_pinned"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct ForumReply: Codable, Identifiable {
    let id: String
    let threadId: String
    let content: String
    let author: UserBasic
    let upvotes: Int
    let isBestAnswer: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case threadId = "thread_id"
        case content, author, upvotes
        case isBestAnswer = "is_best_answer"
        case createdAt = "created_at"
    }
}

// MARK: - Study Groups

struct StudyGroup: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let isPublic: Bool
    let memberCount: Int
    let maxMembers: Int
    let courseId: String?
    let createdBy: UserBasic
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case isPublic = "is_public"
        case memberCount = "member_count"
        case maxMembers = "max_members"
        case courseId = "course_id"
        case createdBy = "created_by"
    }
}

// MARK: - Messaging

struct Conversation: Codable, Identifiable {
    let id: String
    let participants: [UserBasic]
    let lastMessage: Message?
    let unreadCount: Int
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, participants
        case lastMessage = "last_message"
        case unreadCount = "unread_count"
        case updatedAt = "updated_at"
    }
}

struct Message: Codable, Identifiable {
    let id: String
    let conversationId: String
    let senderId: String
    let content: String
    let isRead: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case conversationId = "conversation_id"
        case senderId = "sender_id"
        case content
        case isRead = "is_read"
        case createdAt = "created_at"
    }
}

// MARK: - Common

struct UserBasic: Codable {
    let id: String
    let username: String
    let avatar: String?
    let level: Int?
}
