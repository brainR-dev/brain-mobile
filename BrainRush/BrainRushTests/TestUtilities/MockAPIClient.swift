//
//  MockAPIClient.swift
//  BrainRushTests
//
//  Mock API client for testing
//

import Foundation
@testable import BrainRush

class MockAPIClient {
    static var shared = MockAPIClient()
    
    var mockResponses: [String: Any] = [:]
    var mockErrors: [String: Error] = [:]
    var requestHistory: [(endpoint: String, method: String)] = []
    
    private init() {}
    
    func reset() {
        mockResponses.removeAll()
        mockErrors.removeAll()
        requestHistory.removeAll()
    }
    
    func mockResponse<T: Codable>(_ response: T, for endpoint: String) {
        mockResponses[endpoint] = response
    }
    
    func mockError(_ error: Error, for endpoint: String) {
        mockErrors[endpoint] = error
    }
    
    func didCallEndpoint(_ endpoint: String) -> Bool {
        requestHistory.contains { $0.endpoint.contains(endpoint) }
    }
    
    func callCount(for endpoint: String) -> Int {
        requestHistory.filter { $0.endpoint.contains(endpoint) }.count
    }
}

// Mock APIClient extension for testing
extension APIClient {
    #if DEBUG
    static var mockMode: Bool = false
    static var mockClient: MockAPIClient = MockAPIClient.shared
    #endif
}
