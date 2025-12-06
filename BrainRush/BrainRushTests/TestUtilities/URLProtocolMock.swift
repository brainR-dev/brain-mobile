//
//  URLProtocolMock.swift
//  BrainRushTests
//
//  Mock URLProtocol for intercepting network requests in tests
//

import Foundation

class URLProtocolMock: URLProtocol {
    static var mockResponses: [URL: (data: Data?, response: URLResponse?, error: Error?)] = [:]
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        
        // Check for mock response
        if let mock = URLProtocolMock.mockResponses[url] {
            if let response = mock.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = mock.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let error = mock.error {
                client?.urlProtocol(self, didFailWithError: error)
            } else {
                client?.urlProtocolDidFinishLoading(self)
            }
            return
        }
        
        // Use request handler if available
        guard let handler = URLProtocolMock.requestHandler else {
            let error = NSError(domain: "MockError", code: 500, userInfo: [
                NSLocalizedDescriptionKey: "No mock response configured"
            ])
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No-op
    }
    
    // MARK: - Helper Methods
    
    static func mockResponse(for url: URL, data: Data?, statusCode: Int = 200) {
        let response = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )
        mockResponses[url] = (data: data, response: response, error: nil)
    }
    
    static func mockError(for url: URL, error: Error) {
        mockResponses[url] = (data: nil, response: nil, error: error)
    }
    
    static func clearMocks() {
        mockResponses.removeAll()
        requestHandler = nil
    }
}
