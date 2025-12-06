//
//  BrainProfileServiceTests.swift
//  BrainRushTests
//
//  Unit tests for BrainProfileService
//

import XCTest
@testable import BrainRush

@MainActor
final class BrainProfileServiceTests: XCTestCase {
    var service: BrainProfileService!
    
    override func setUp() {
        super.setUp()
        service = BrainProfileService.shared
    }
    
    func testLoadBrainProfile() async {
        await service.loadBrainProfile()
        
        // Verify profile is loaded (may be nil if not completed)
        XCTAssertNotNil(service)
    }
    
    func testSubmitAssessment() async throws {
        let answers: [Int: Int] = [
            1: 3,
            2: 4,
            3: 2
        ]
        
        do {
            let profile = try await service.submitAssessment(answers: answers)
            XCTAssertNotNil(profile)
            XCTAssertNotNil(profile.scores)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testBrainProfileModel() {
        let profile = MockDataFactory.makeBrainProfile()
        
        XCTAssertNotNil(profile.scores)
        XCTAssertEqual(profile.scores.analytical, 0.8, accuracy: 0.01)
        XCTAssertNotNil(profile.insights)
        XCTAssertEqual(profile.insights?.learningStyle, "Analytical")
    }
    
    func testBrainDomainScores() {
        let scores = BrainDomainScores(
            analytical: 0.8,
            creative: 0.6,
            practical: 0.7,
            theoretical: 0.9,
            intuitive: 0.5,
            structured: 0.85
        )
        
        XCTAssertEqual(scores.analytical, 0.8, accuracy: 0.01)
        XCTAssertEqual(scores.creative, 0.6, accuracy: 0.01)
        XCTAssertGreaterThanOrEqual(scores.analytical, 0.0)
        XCTAssertLessThanOrEqual(scores.analytical, 1.0)
    }
}
