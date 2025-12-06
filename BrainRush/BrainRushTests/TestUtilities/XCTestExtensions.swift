//
//  XCTestExtensions.swift
//  BrainRushTests
//
//  XCTest extensions for better test assertions
//

import XCTest
import Combine
@testable import BrainRush

extension XCTestCase {
    
    // MARK: - Async Helpers
    
    func waitForAsync( timeout: TimeInterval = 2.0, _ block: @escaping () async throws -> Void) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            Task {
                do {
                    try await block()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func expectToComplete<T>(
        _ asyncBlock: @escaping () async throws -> T,
        timeout: TimeInterval = 2.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            Task {
                do {
                    let result = try await asyncBlock()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Combine Helpers
    
    func waitForPublisher<T>(
        _ publisher: some Publisher<T, Never>,
        timeout: TimeInterval = 2.0,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> T? {
        let expectation = expectation(description: "Wait for publisher")
        var result: T?
        var cancellable: AnyCancellable?
        
        cancellable = publisher
            .sink(
                receiveValue: { value in
                    result = value
                    cancellable?.cancel()
                    expectation.fulfill()
                }
            )
        
        wait(for: [expectation], timeout: timeout)
        return result
    }
    
    // MARK: - Assertion Helpers
    
    func assertNotEmpty<T: Collection>(
        _ collection: T?,
        message: String = "Collection should not be empty",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertNotNil(collection, message, file: file, line: line)
        XCTAssertFalse(collection?.isEmpty ?? true, message, file: file, line: line)
    }
    
    func assertValidEmail(
        _ email: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(
            Validation.isValidEmail(email),
            "Expected valid email: \(email)",
            file: file,
            line: line
        )
    }
    
    func assertInvalidEmail(
        _ email: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertFalse(
            Validation.isValidEmail(email),
            "Expected invalid email: \(email)",
            file: file,
            line: line
        )
    }
    
    // MARK: - Model Helpers
    
    func assertCourseDecodes(
        _ json: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws -> Course {
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(Course.self, from: data)
    }
    
    // MARK: - Time Helpers
    
    func measureAsyncTime(_ block: @escaping () async throws -> Void) async throws -> TimeInterval {
        let start = Date()
        try await block()
        return Date().timeIntervalSince(start)
    }
}

// MARK: - Publisher Extension

extension Publisher where Failure == Never {
    func waitForValue(timeout: TimeInterval = 2.0) -> Output? {
        let expectation = XCTestExpectation(description: "Wait for publisher value")
        var result: Output?
        var cancellable: AnyCancellable?
        
        cancellable = self
            .sink { value in
                result = value
                cancellable?.cancel()
                expectation.fulfill()
            }
        
        XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result
    }
}
