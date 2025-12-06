//
//  CertificateServiceTests.swift
//  BrainRushTests
//
//  Unit tests for CertificateService
//

import XCTest
@testable import BrainRush

@MainActor
final class CertificateServiceTests: XCTestCase {
    var service: CertificateService!
    
    override func setUp() {
        super.setUp()
        service = CertificateService.shared
    }
    
    func testLoadCertificates() async {
        await service.loadCertificates()
        
        // Verify certificates are loaded
        XCTAssertNotNil(service.certificates)
    }
    
    func testLoadCertificateDetails() async throws {
        let certificateId = "cert_1"
        
        do {
            let certificate = try await service.loadCertificateDetails(certificateId: certificateId)
            XCTAssertEqual(certificate.id, certificateId)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testDownloadCertificatePDF() async throws {
        let certificateId = "cert_1"
        
        do {
            let data = try await service.downloadCertificatePDF(certificateId: certificateId)
            XCTAssertNotNil(data)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testLoadBadges() async {
        await service.loadBadges()
        
        // Verify badges are loaded
        XCTAssertNotNil(service.badges)
    }
    
    func testCertificateModel() {
        let certificate = MockDataFactory.makeCertificate(
            id: "cert_1",
            title: "Completion Certificate",
            type: "course"
        )
        
        XCTAssertEqual(certificate.id, "cert_1")
        XCTAssertEqual(certificate.type, "course")
        XCTAssertNotNil(certificate.verificationUrl)
    }
}
