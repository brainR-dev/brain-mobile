//
//  SocialTests.swift
//  BrainRushTests
//
//  Unit tests for Social models
//

import XCTest
@testable import BrainRush

final class SocialTests: XCTestCase {
    
    func testForumDecoding() throws {
        let json = """
        {
            "id": "forum_1",
            "name": "General Discussion",
            "description": "General forum",
            "course_id": null,
            "domain": null,
            "thread_count": 10
        }
        """
        
        let forum = try TestHelpers.decodeJSON(json, as: Forum.self)
        
        XCTAssertEqual(forum.id, "forum_1")
        XCTAssertEqual(forum.name, "General Discussion")
        XCTAssertEqual(forum.threadCount, 10)
    }
    
    func testForumThreadDecoding() throws {
        let json = """
        {
            "id": "thread_1",
            "forum_id": "forum_1",
            "title": "Test Thread",
            "content": "Thread content",
            "author": {
                "id": "user_1",
                "username": "testuser",
                "avatar": null,
                "level": 5
            },
            "reply_count": 5,
            "view_count": 100,
            "upvotes": 10,
            "is_pinned": false,
            "created_at": "2024-01-01T00:00:00Z",
            "updated_at": "2024-01-01T00:00:00Z"
        }
        """
        
        let thread = try TestHelpers.decodeJSON(json, as: ForumThread.self)
        
        XCTAssertEqual(thread.id, "thread_1")
        XCTAssertEqual(thread.forumId, "forum_1")
        XCTAssertEqual(thread.title, "Test Thread")
        XCTAssertEqual(thread.author.username, "testuser")
        XCTAssertEqual(thread.replyCount, 5)
        XCTAssertEqual(thread.upvotes, 10)
    }
    
    func testStudyGroupDecoding() throws {
        let json = """
        {
            "id": "group_1",
            "name": "Study Group 1",
            "description": "Test group",
            "is_public": true,
            "member_count": 5,
            "max_members": 10,
            "course_id": "course_1",
            "created_by": {
                "id": "user_1",
                "username": "testuser",
                "avatar": null,
                "level": 5
            }
        }
        """
        
        let group = try TestHelpers.decodeJSON(json, as: StudyGroup.self)
        
        XCTAssertEqual(group.id, "group_1")
        XCTAssertEqual(group.name, "Study Group 1")
        XCTAssertTrue(group.isPublic)
        XCTAssertEqual(group.memberCount, 5)
        XCTAssertEqual(group.maxMembers, 10)
    }
    
    func testUserBasicDecoding() throws {
        let json = """
        {
            "id": "user_1",
            "username": "testuser",
            "avatar": null,
            "level": 5
        }
        """
        
        let user = try TestHelpers.decodeJSON(json, as: UserBasic.self)
        
        XCTAssertEqual(user.id, "user_1")
        XCTAssertEqual(user.username, "testuser")
        XCTAssertEqual(user.level, 5)
    }
}
