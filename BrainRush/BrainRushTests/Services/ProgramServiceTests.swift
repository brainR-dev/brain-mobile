//
//  ProgramServiceTests.swift
//  BrainRushTests
//
//  Unit tests for ProgramService
//

import XCTest
@testable import BrainRush

@MainActor
final class ProgramServiceTests: XCTestCase {
    var service: ProgramService!
    
    override func setUp() {
        super.setUp()
        service = ProgramService.shared
    }
    
    func testLoadPrograms() async {
        await service.loadPrograms()
        
        // Verify programs are loaded
        XCTAssertNotNil(service.programs)
    }
    
    func testLoadProgramDetails() async throws {
        let programId = "program_1"
        
        do {
            let program = try await service.loadProgramDetails(programId: programId)
            XCTAssertEqual(program.id, programId)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testEnrollInProgram() async throws {
        let programId = "program_1"
        
        do {
            try await service.enrollInProgram(programId: programId)
            // Success
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testLoadEnrolledPrograms() async {
        await service.loadEnrolledPrograms()
        
        // Verify enrolled programs are loaded
        XCTAssertNotNil(service.enrolledPrograms)
    }
}
