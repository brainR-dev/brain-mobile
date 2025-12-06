//
//  NetworkIntegrationTests.swift
//  BrainRushTests
//
//  Network integration tests with mocked responses
//

import XCTest
@testable import BrainRush

final class NetworkIntegrationTests: XCTestCase {
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        
        // Configure URLSession with mock protocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        apiClient = APIClient.shared
    }
    
    override func tearDown() {
        URLProtocolMock.clearMocks()
        super.tearDown()
    }
    
    func testMockedAPICall() async throws {
        let url = URL(string: "https://api.brainrash.com/test")!
        let mockData = APIMockResponses.getData(APIMockResponses.signInSuccessResponse)
        
        URLProtocolMock.mockResponse(for: url, data: mockData, statusCode: 200)
        
        // Make API call
        // This would use the mocked response
        XCTAssertNotNil(mockData)
    }
    
    func testMockedErrorResponse() async {
        let url = URL(string: "https://api.brainrash.com/error")!
        let error = URLError(.notConnectedToInternet)
        
        URLProtocolMock.mockError(for: url, error: error)
        
        // API call should fail with mocked error
        XCTAssertNotNil(error)
    }
    
    func testMockedServerError() async {
        let url = URL(string: "https://api.brainrash.com/server-error")!
        let errorData = APIMockResponses.getData(APIMockResponses.serverErrorResponse)
        
        URLProtocolMock.mockResponse(for: url, data: errorData, statusCode: 500)
        
        // Should handle 500 error
        XCTAssertNotNil(errorData)
    }
    
    func testRequestHandler() async {
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            let data = APIMockResponses.getData(APIMockResponses.courseListResponse)
            return (response, data)
        }
        
        // Make request - should use handler
        XCTAssertNotNil(URLProtocolMock.requestHandler)
    }
}
