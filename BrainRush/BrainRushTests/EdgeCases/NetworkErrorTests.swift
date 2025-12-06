//
//  NetworkErrorTests.swift
//  BrainRushTests
//
//  Tests for network error scenarios
//

import XCTest
@testable import BrainRush

final class NetworkErrorTests: XCTestCase {
    
    func testNoInternetConnection() async {
        // Simulate no internet connection
        let error = APIError.networkError(
            NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        )
        
        if case .networkError(let nsError) = error {
            XCTAssertEqual(nsError.code, NSURLErrorNotConnectedToInternet)
        } else {
            XCTFail("Expected network error")
        }
    }
    
    func testTimeoutError() {
        let error = APIError.networkError(
            NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
        )
        
        if case .networkError(let nsError) = error {
            XCTAssertEqual(nsError.code, NSURLErrorTimedOut)
        } else {
            XCTFail("Expected timeout error")
        }
    }
    
    func testDNSFailure() {
        let error = APIError.networkError(
            NSError(domain: NSURLErrorDomain, code: NSURLErrorDNSLookupFailed)
        )
        
        if case .networkError(let nsError) = error {
            XCTAssertEqual(nsError.code, NSURLErrorDNSLookupFailed)
        } else {
            XCTFail("Expected DNS error")
        }
    }
    
    func testCannotConnectToHost() {
        let error = APIError.networkError(
            NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost)
        )
        
        if case .networkError(let nsError) = error {
            XCTAssertEqual(nsError.code, NSURLErrorCannotConnectToHost)
        } else {
            XCTFail("Expected connection error")
        }
    }
    
    func testNetworkUnavailable() {
        let error = APIError.networkError(
            NSError(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost)
        )
        
        if case .networkError(let nsError) = error {
            XCTAssertEqual(nsError.code, NSURLErrorNetworkConnectionLost)
        } else {
            XCTFail("Expected network unavailable error")
        }
    }
}

#if canImport(Foundation)
import Foundation
#endif
