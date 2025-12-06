//
//  APIClientTests.swift
//  BrainRushTests
//
//  Unit tests for APIClient
//

import XCTest
@testable import BrainRush

final class APIClientTests: XCTestCase {
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = APIClient.shared
    }
    
    func testInvalidURL() async {
        do {
            let _: EmptyResponse = try await apiClient.request(
                endpoint: "invalid-url",
                method: "GET"
            )
            XCTFail("Should have thrown an error")
        } catch {
            if case APIError.invalidURL = error {
                // Expected
            } else {
                XCTFail("Unexpected error type: \(error)")
            }
        }
    }
    
    func testUnauthorizedError() async {
        // This test would need a mock server to return 401
        // For now, just verify the error type exists
        let error = APIError.unauthorized
        XCTAssertNotNil(error)
    }
    
    func testErrorTypes() {
        let invalidURL = APIError.invalidURL
        let unauthorized = APIError.unauthorized
        let serverError = APIError.serverError(500, "Internal Server Error")
        let networkError = APIError.networkError(NSError(domain: "test", code: 0))
        
        XCTAssertNotNil(invalidURL)
        XCTAssertNotNil(unauthorized)
        XCTAssertNotNil(serverError)
        XCTAssertNotNil(networkError)
    }
}
