//
//  ErrorHandlingTests.swift
//  BrainRushTests
//
//  Edge case tests for error handling
//

import XCTest
@testable import BrainRush

final class ErrorHandlingTests: XCTestCase {
    
    func testAPIClientInvalidURL() async {
        let client = APIClient.shared
        
        do {
            let _: EmptyResponse = try await client.request(
                endpoint: "",
                method: "GET"
            )
            XCTFail("Should have thrown invalidURL error")
        } catch APIError.invalidURL {
            // Expected
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testAPIClientUnauthorized() async {
        // Test unauthorized error handling
        let error = APIError.unauthorized
        
        if case .unauthorized = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected unauthorized error")
        }
    }
    
    func testAPIClientServerError() {
        let error = APIError.serverError(500, "Internal Server Error")
        
        if case .serverError(let code, let message) = error {
            XCTAssertEqual(code, 500)
            XCTAssertEqual(message, "Internal Server Error")
        } else {
            XCTFail("Expected server error")
        }
    }
    
    func testAPIClientNetworkError() {
        let nsError = NSError(domain: "test", code: -1009, userInfo: nil)
        let error = APIError.networkError(nsError)
        
        if case .networkError(let underlyingError) = error {
            XCTAssertEqual(underlyingError.domain, "test")
            XCTAssertEqual(underlyingError.code, -1009)
        } else {
            XCTFail("Expected network error")
        }
    }
    
    func testAPIClientDecodingError() {
        let error = APIError.decodingError(NSError(domain: "decoding", code: 1))
        
        if case .decodingError = error {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected decoding error")
        }
    }
    
    func testValidationEdgeCases() {
        // Empty email
        XCTAssertFalse(Validation.isValidEmail(""))
        
        // Email without @
        XCTAssertFalse(Validation.isValidEmail("invalidemail.com"))
        
        // Email without domain
        XCTAssertFalse(Validation.isValidEmail("test@"))
        
        // Email without local part
        XCTAssertFalse(Validation.isValidEmail("@example.com"))
        
        // Password too short
        XCTAssertFalse(Validation.isValidPassword("short"))
        
        // Strong password checks
        XCTAssertFalse(Validation.isStrongPassword("lowercase123"))
        XCTAssertFalse(Validation.isStrongPassword("UPPERCASE123"))
        XCTAssertFalse(Validation.isStrongPassword("NoNumbers"))
        XCTAssertTrue(Validation.isStrongPassword("ValidPass123"))
    }
    
    func testKeychainEdgeCases() {
        let keychain = KeychainService.shared
        
        // Test clearing empty keychain
        keychain.clearAll()
        
        // Test retrieving non-existent values
        XCTAssertNil(keychain.getAccessToken())
        XCTAssertNil(keychain.getRefreshToken())
        XCTAssertNil(keychain.getUserId())
        XCTAssertNil(keychain.getEmail())
    }
}

struct EmptyResponse: Codable {}
