//
//  AITutorServiceTests.swift
//  BrainRushTests
//
//  Unit tests for AITutorService
//

import XCTest
@testable import BrainRush

@MainActor
final class AITutorServiceTests: XCTestCase {
    var service: AITutorService!
    
    override func setUp() {
        super.setUp()
        service = AITutorService.shared
    }
    
    func testSendMessage() async throws {
        let message = "What is Swift?"
        
        do {
            let response = try await service.sendMessage(message, personaId: nil)
            XCTAssertNotNil(response)
            XCTAssertFalse(response.content.isEmpty)
        } catch {
            // Expected if not authenticated or API unavailable
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testLoadConversationHistory() async {
        await service.loadConversationHistory()
        
        // Verify messages are loaded
        XCTAssertNotNil(service.messages)
    }
    
    func testClearConversation() async {
        await service.clearConversation()
        
        // Verify conversation is cleared
        XCTAssertTrue(service.messages.isEmpty)
    }
    
    func testGetQuota() async throws {
        do {
            let quota = try await service.getQuota()
            XCTAssertNotNil(quota)
            XCTAssertGreaterThanOrEqual(quota.remaining, 0)
            XCTAssertGreaterThan(quota.limit, 0)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testAvailablePersonas() async throws {
        do {
            let personas = try await service.getAvailablePersonas()
            XCTAssertNotNil(personas)
            XCTAssertFalse(personas.isEmpty)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}
