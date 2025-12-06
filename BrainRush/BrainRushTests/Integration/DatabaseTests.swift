//
//  DatabaseTests.swift
//  BrainRushTests
//
//  SwiftData integration tests
//

import XCTest
import SwiftData
@testable import BrainRush

final class DatabaseTests: XCTestCase {
    var modelContainer: ModelContainer!
    var context: ModelContext!
    
    override func setUp() {
        super.setUp()
        let schema = Schema([UserProfile.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
            context = modelContainer.mainContext
        } catch {
            XCTFail("Failed to create model container: \(error)")
        }
    }
    
    override func tearDown() {
        modelContainer = nil
        context = nil
        super.tearDown()
    }
    
    func testSaveUserProfile() throws {
        let profile = MockDataFactory.makeUserProfile()
        context.insert(profile)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(fetchDescriptor)
        
        XCTAssertEqual(profiles.count, 1)
        XCTAssertEqual(profiles.first?.id, profile.id)
    }
    
    func testFetchUserProfile() throws {
        let profile = MockDataFactory.makeUserProfile(id: "test_user")
        context.insert(profile)
        try context.save()
        
        var fetchDescriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate<UserProfile> { $0.id == "test_user" }
        )
        let fetched = try context.fetch(fetchDescriptor)
        
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, "test_user")
    }
    
    func testUpdateUserProfile() throws {
        var profile = MockDataFactory.makeUserProfile()
        context.insert(profile)
        try context.save()
        
        profile.email = "updated@example.com"
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(fetchDescriptor)
        
        XCTAssertEqual(profiles.first?.email, "updated@example.com")
    }
    
    func testDeleteUserProfile() throws {
        let profile = MockDataFactory.makeUserProfile()
        context.insert(profile)
        try context.save()
        
        context.delete(profile)
        try context.save()
        
        let fetchDescriptor = FetchDescriptor<UserProfile>()
        let profiles = try context.fetch(fetchDescriptor)
        
        XCTAssertTrue(profiles.isEmpty)
    }
}
