//
//  SocialServiceTests.swift
//  BrainRushTests
//
//  Unit tests for SocialService
//

import XCTest
@testable import BrainRush

@MainActor
final class SocialServiceTests: XCTestCase {
    var service: SocialService!
    
    override func setUp() {
        super.setUp()
        service = SocialService.shared
    }
    
    func testLoadForums() async {
        await service.loadForums()
        
        // Verify forums are loaded
        XCTAssertNotNil(service.forums)
    }
    
    func testLoadStudyGroups() async {
        await service.loadStudyGroups()
        
        // Verify study groups are loaded
        XCTAssertNotNil(service.studyGroups)
    }
    
    func testLoadConversations() async {
        await service.loadConversations()
        
        // Verify conversations are loaded
        XCTAssertNotNil(service.conversations)
    }
    
    func testForumModel() {
        let forum = MockDataFactory.makeForum(
            id: "forum_1",
            name: "Test Forum",
            threadCount: 10
        )
        
        XCTAssertEqual(forum.id, "forum_1")
        XCTAssertEqual(forum.name, "Test Forum")
        XCTAssertEqual(forum.threadCount, 10)
    }
    
    func testStudyGroupModel() {
        // Test study group creation
        let group = StudyGroup(
            id: "group_1",
            name: "Test Group",
            description: "Test",
            isPublic: true,
            memberCount: 5,
            maxMembers: 10,
            courseId: nil,
            createdBy: MockDataFactory.makeUserBasic()
        )
        
        XCTAssertEqual(group.id, "group_1")
        XCTAssertTrue(group.isPublic)
        XCTAssertEqual(group.memberCount, 5)
    }
}
