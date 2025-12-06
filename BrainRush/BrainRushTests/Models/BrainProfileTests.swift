//
//  BrainProfileTests.swift
//  BrainRushTests
//
//  Unit tests for BrainProfile models
//

import XCTest
@testable import BrainRush

final class BrainProfileTests: XCTestCase {
    
    func testBrainProfileDecoding() throws {
        let json = """
        {
            "user_id": "user_1",
            "scores": {
                "analytical": 0.8,
                "creative": 0.6,
                "practical": 0.7,
                "theoretical": 0.9,
                "intuitive": 0.5,
                "structured": 0.85
            },
            "insights": {
                "learning_style": "Analytical",
                "strengths": ["Problem Solving", "Analysis"],
                "growth_areas": ["Creativity", "Intuition"],
                "recommendations": ["Try creative courses"]
            },
            "recommendations": ["Course 1", "Course 2"],
            "completed_at": "2024-01-01T00:00:00Z"
        }
        """
        
        let profile = try TestHelpers.decodeJSON(json, as: BrainProfile.self)
        
        XCTAssertEqual(profile.userId, "user_1")
        XCTAssertNotNil(profile.scores)
        XCTAssertEqual(profile.scores.analytical, 0.8, accuracy: 0.01)
        XCTAssertNotNil(profile.insights)
        XCTAssertEqual(profile.insights?.learningStyle, "Analytical")
        XCTAssertEqual(profile.recommendations?.count, 2)
    }
    
    func testBrainDomainScoresDecoding() throws {
        let json = """
        {
            "analytical": 0.8,
            "creative": 0.6,
            "practical": 0.7,
            "theoretical": 0.9,
            "intuitive": 0.5,
            "structured": 0.85
        }
        """
        
        let scores = try TestHelpers.decodeJSON(json, as: BrainDomainScores.self)
        
        XCTAssertEqual(scores.analytical, 0.8, accuracy: 0.01)
        XCTAssertEqual(scores.creative, 0.6, accuracy: 0.01)
        XCTAssertEqual(scores.practical, 0.7, accuracy: 0.01)
        XCTAssertEqual(scores.theoretical, 0.9, accuracy: 0.01)
        XCTAssertEqual(scores.intuitive, 0.5, accuracy: 0.01)
        XCTAssertEqual(scores.structured, 0.85, accuracy: 0.01)
    }
    
    func testBrainProfileInsightsDecoding() throws {
        let json = """
        {
            "learning_style": "Analytical",
            "strengths": ["Problem Solving", "Analysis"],
            "growth_areas": ["Creativity", "Intuition"],
            "recommendations": ["Try creative courses", "Explore intuitive learning"]
        }
        """
        
        let insights = try TestHelpers.decodeJSON(json, as: BrainProfileInsights.self)
        
        XCTAssertEqual(insights.learningStyle, "Analytical")
        XCTAssertEqual(insights.strengths.count, 2)
        XCTAssertEqual(insights.growthAreas.count, 2)
        XCTAssertEqual(insights.recommendations.count, 2)
    }
    
    func testBrainDomainScoresValidation() {
        let scores = BrainDomainScores(
            analytical: 0.8,
            creative: 0.6,
            practical: 0.7,
            theoretical: 0.9,
            intuitive: 0.5,
            structured: 0.85
        )
        
        // All scores should be between 0 and 1
        XCTAssertGreaterThanOrEqual(scores.analytical, 0.0)
        XCTAssertLessThanOrEqual(scores.analytical, 1.0)
        XCTAssertGreaterThanOrEqual(scores.creative, 0.0)
        XCTAssertLessThanOrEqual(scores.creative, 1.0)
    }
}
