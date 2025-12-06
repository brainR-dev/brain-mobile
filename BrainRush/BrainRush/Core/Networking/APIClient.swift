//
//  APIClient.swift
//  BrainRush
//
//  API client for BrainRash API
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case unauthorized
    case serverError(Int, String?)
    case unknown
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let error: String?
    let message: String?
    let errors: [APIErrorDetail]?
}

struct APIErrorDetail: Codable {
    let field: String?
    let message: String
}

class APIClient {
    static let shared = APIClient()
    
    private let baseURL = AppConfig.apiBaseURL
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil,
        headers: [String: String]? = nil,
        accessToken: String? = nil
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // Set headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AppConfig.bundleID, forHTTPHeaderField: "X-Client-App")
        request.setValue("ios", forHTTPHeaderField: "X-Platform")
        
        // Add auth token if provided
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add custom headers
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set body if provided
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        do {
            let startTime = Date()
            let (data, response) = try await session.data(for: request)
            let duration = Date().timeIntervalSince(startTime) * 1000 // milliseconds
            
            guard let httpResponse = response as? HTTPURLResponse else {
                AnalyticsService.shared.trackError(APIError.unknown, context: [
                    "endpoint": endpoint,
                    "method": method
                ])
                throw APIError.unknown
            }
            
            // Track API performance
            AnalyticsService.shared.trackPerformance(
                metricName: "api_request",
                value: duration,
                unit: "ms"
            )
            
            // Handle status codes
            switch httpResponse.statusCode {
            case 200...299:
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                if let apiResponse = try? decoder.decode(APIResponse<T>.self, from: data) {
                    if apiResponse.success, let data = apiResponse.data {
                        return data
                    } else if let error = apiResponse.error {
                        throw APIError.serverError(httpResponse.statusCode, error)
                    }
                }
                
                // Try direct decoding if not wrapped in APIResponse
                return try decoder.decode(T.self, from: data)
                
            case 401:
                AnalyticsService.shared.trackError(
                    APIError.unauthorized,
                    context: [
                        "endpoint": endpoint,
                        "method": method,
                        "status_code": httpResponse.statusCode
                    ]
                )
                throw APIError.unauthorized
            case 400...499:
                let errorMessage: String?
                if let errorResponse = try? JSONDecoder().decode(APIResponse<EmptyResponse>.self, from: data) {
                    errorMessage = errorResponse.message
                    AnalyticsService.shared.trackError(
                        APIError.serverError(httpResponse.statusCode, errorMessage),
                        context: [
                            "endpoint": endpoint,
                            "method": method,
                            "status_code": httpResponse.statusCode,
                            "error_message": errorMessage ?? "Unknown"
                        ]
                    )
                    throw APIError.serverError(httpResponse.statusCode, errorMessage)
                }
                AnalyticsService.shared.trackError(
                    APIError.serverError(httpResponse.statusCode, nil),
                    context: [
                        "endpoint": endpoint,
                        "method": method,
                        "status_code": httpResponse.statusCode
                    ]
                )
                throw APIError.serverError(httpResponse.statusCode, nil)
            case 500...599:
                let serverError = APIError.serverError(httpResponse.statusCode, "Server error")
                AnalyticsService.shared.trackError(
                    serverError,
                    context: [
                        "endpoint": endpoint,
                        "method": method,
                        "status_code": httpResponse.statusCode,
                        "error_type": "server_error"
                    ]
                )
                throw serverError
            default:
                AnalyticsService.shared.trackError(
                    APIError.unknown,
                    context: [
                        "endpoint": endpoint,
                        "method": method,
                        "status_code": httpResponse.statusCode
                    ]
                )
                throw APIError.unknown
            }
        } catch let error as APIError {
            // Error already tracked above
            throw error
        } catch let error as DecodingError {
            let decodingError = APIError.decodingError(error)
            AnalyticsService.shared.trackError(
                decodingError,
                context: [
                    "endpoint": endpoint,
                    "method": method,
                    "error_type": "decoding_error"
                ]
            )
            throw decodingError
        } catch {
            let networkError = APIError.networkError(error)
            AnalyticsService.shared.trackError(
                networkError,
                context: [
                    "endpoint": endpoint,
                    "method": method,
                    "error_type": "network_error",
                    "error_message": error.localizedDescription
                ]
            )
            throw networkError
        }
    }
}

// Empty response for error parsing
struct EmptyResponse: Codable {}
