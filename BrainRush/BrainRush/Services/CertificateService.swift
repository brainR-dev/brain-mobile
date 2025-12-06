//
//  CertificateService.swift
//  BrainRush
//
//  Certificate service
//

import Foundation

@MainActor
class CertificateService: ObservableObject {
    static let shared = CertificateService()
    
    @Published var certificates: [Certificate] = []
    @Published var badges: [Badge] = []
    @Published var isLoading = false
    
    private init() {}
    
    func loadCertificates() async {
        isLoading = true
        defer { isLoading = false }
        
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let certificates: [Certificate] = try await APIClient.shared.request(
                endpoint: "/mobile/certificates",
                method: "GET",
                accessToken: token
            )
            self.certificates = certificates
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_certificates"
            ])
        }
    }
    
    func loadCertificateDetails(certificateId: String) async throws -> Certificate {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let certificate: Certificate = try await APIClient.shared.request(
            endpoint: "/mobile/certificates/\(certificateId)",
            method: "GET",
            accessToken: token
        )
        return certificate
    }
    
    func downloadCertificatePDF(certificateId: String) async throws -> Data {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        // Download PDF data
        let data: Data = try await APIClient.shared.request(
            endpoint: "/mobile/certificates/\(certificateId)/download",
            method: "GET",
            accessToken: token
        )
        return data
    }
    
    func loadBadges() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let badges: [Badge] = try await APIClient.shared.request(
                endpoint: "/mobile/badges",
                method: "GET",
                accessToken: token
            )
            self.badges = badges
        } catch {
            // Handle error
        }
    }
}
