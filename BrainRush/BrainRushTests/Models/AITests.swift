//
//  AITests.swift
//  BrainRushTests
//
//  Unit tests for AI models
//

import XCTest
@testable import BrainRush

final class AITests: XCTestCase {
    
    func testAITutorPersonaDecoding() throws {
        let json = """
        {
            "id": "persona_1",
            "name": "Tutor",
            "description": "Educational & thorough",
            "icon": null
        }
        """
        
        let persona = try TestHelpers.decodeJSON(json, as: AITutorPersona.self)
        
        XCTAssertEqual(persona.id, "persona_1")
        XCTAssertEqual(persona.name, "Tutor")
        XCTAssertEqual(persona.description, "Educational & thorough")
    }
    
    func testAITutorMessageDecoding() throws {
        let json = """
        {
            "id": "msg_1",
            "role": "assistant",
            "content": "Hello! How can I help you?",
            "created_at": "2024-01-01T00:00:00Z",
            "persona_id": "persona_1"
        }
        """
        
        let message = try TestHelpers.decodeJSON(json, as: AITutorMessage.self)
        
        XCTAssertEqual(message.id, "msg_1")
        XCTAssertEqual(message.role, "assistant")
        XCTAssertEqual(message.content, "Hello! How can I help you?")
        XCTAssertEqual(message.personaId, "persona_1")
    }
    
    func testAITutorQuotaDecoding() throws {
        let json = """
        {
            "remaining": 50,
            "limit": 100,
            "reset_at": "2024-01-02T00:00:00Z"
        }
        """
        
        let quota = try TestHelpers.decodeJSON(json, as: AITutorQuota.self)
        
        XCTAssertEqual(quota.remaining, 50)
        XCTAssertEqual(quota.limit, 100)
    }
    
    func testStudyScheduleDecoding() throws {
        let json = """
        {
            "id": "schedule_1",
            "sessions": [
                {
                    "id": "session_1",
                    "course_id": "course_1",
                    "title": "Study Session 1",
                    "start_time": "2024-01-01T10:00:00Z",
                    "duration": 60,
                    "is_completed": false
                }
            ],
            "predictions": {
                "completion_date": "2024-02-01T00:00:00Z",
                "risk_factors": [],
                "confidence": 0.85
            }
        }
        """
        
        let schedule = try TestHelpers.decodeJSON(json, as: StudySchedule.self)
        
        XCTAssertEqual(schedule.id, "schedule_1")
        XCTAssertEqual(schedule.sessions.count, 1)
        XCTAssertNotNil(schedule.predictions)
        XCTAssertEqual(schedule.predictions?.confidence, 0.85, accuracy: 0.01)
    }
}
