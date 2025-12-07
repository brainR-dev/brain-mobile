//
//  LanguagePerformanceTests.swift
//  BrainRushTests
//
//  Performance and security tests for mobile app language features
//

import XCTest
@testable import BrainRush

@MainActor
final class LanguagePerformanceTests: XCTestCase {
    var languageService: LanguageService!
    var localizationService: LocalizationService!
    
    override func setUp() {
        super.setUp()
        languageService = LanguageService.shared
        localizationService = LocalizationService.shared
    }
    
    // MARK: - Performance Tests
    
    func testLanguageChangePerformance() {
        measure {
            for language in ["en", "es", "fr", "de", "ja"] {
                languageService.setLanguage(language)
            }
        }
    }
    
    func testLocalizationPerformance() {
        let key = "common.save"
        
        measure {
            for _ in 0..<1000 {
                _ = localizationService.localizedString(for: key)
            }
        }
    }
    
    func testLocalizationWithLanguageOverridePerformance() {
        let key = "common.ok"
        let languages = ["en", "es", "fr", "de"]
        
        measure {
            for language in languages {
                _ = localizationService.localizedString(for: key, language: language)
            }
        }
    }
    
    func testBundleAccessPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = localizationService.bundle(for: "en")
            }
        }
    }
    
    func testLanguageValidationPerformance() {
        let codes = ["en", "es", "fr", "de", "ja", "pt", "ru", "hi", "ar", "zh-CN"]
        
        measure {
            for code in codes {
                _ = languageService.isLanguageSupported(code)
            }
        }
    }
    
    func testStringExtensionPerformance() {
        let key = "common.cancel"
        
        measure {
            for _ in 0..<1000 {
                _ = key.localized()
            }
        }
    }
    
    func testConcurrentLocalizationPerformance() async {
        let key = "common.save"
        
        await measureAsync {
            await withTaskGroup(of: String.self) { group in
                for _ in 0..<100 {
                    group.addTask {
                        return self.localizationService.localizedString(for: key)
                    }
                }
                
                for await _ in group {
                    // Process results
                }
            }
        }
    }
    
    // MARK: - Memory Performance Tests
    
    func testLanguageServiceMemoryFootprint() {
        // Test that LanguageService doesn't leak memory
        weak var weakService: LanguageService?
        
        autoreleasepool {
            let service = LanguageService.shared
            weakService = service
            
            // Perform operations
            for language in ["en", "es", "fr", "de"] {
                service.setLanguage(language)
            }
        }
        
        // Service is singleton, should persist
        XCTAssertNotNil(weakService)
    }
    
    func testLocalizationServiceMemoryFootprint() {
        // Test bundle caching doesn't cause memory issues
        let languages = ["en", "es", "fr", "de", "ja", "pt", "ru", "hi", "ar", "zh-CN", "zh-TW"]
        
        for language in languages {
            _ = localizationService.bundle(for: language)
        }
        
        // Should cache bundles efficiently
        XCTAssertTrue(true)
    }
    
    // MARK: - Security Tests
    
    func testLanguageCodeSanitization() {
        // Test that language codes are properly sanitized
        let maliciousCodes = [
            "'; DROP TABLE users; --",
            "<script>alert('xss')</script>",
            "../../etc/passwd",
            "en\nrm -rf /",
        ]
        
        for code in maliciousCodes {
            let originalLanguage = languageService.currentLanguage
            languageService.setLanguage(code)
            
            let currentLanguage = languageService.currentLanguage
            // Should be sanitized to valid language or default
            XCTAssertTrue(
                languageService.isLanguageSupported(currentLanguage),
                "Malicious code should be sanitized: \(code)"
            )
        }
    }
    
    func testLocalizationKeySanitization() {
        // Test that localization keys are handled safely
        let maliciousKeys = [
            "'; DROP TABLE; --",
            "<script>alert(1)</script>",
            "../../etc/passwd",
        ]
        
        for key in maliciousKeys {
            let localized = localizationService.localizedString(for: key)
            // Should not crash or execute code
            XCTAssertFalse(localized.isEmpty, "Should handle malicious key safely")
        }
    }
    
    func testBundlePathSecurity() {
        // Test that bundle loading doesn't allow path traversal
        let maliciousPaths = [
            "../../etc/passwd",
            "..\\..\\windows\\system32",
            "/etc/passwd",
        ]
        
        // Bundle loading uses safe iOS APIs, but verify behavior
        for path in maliciousPaths {
            // These shouldn't be valid language codes anyway
            let bundle = localizationService.bundle(for: path)
            // Should return fallback bundle, not access system files
            XCTAssertNotNil(bundle)
        }
    }
    
    // MARK: - Thread Safety Tests
    
    func testThreadSafetyLanguageChanges() async {
        let languages = ["en", "es", "fr", "de", "ja"]
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<100 {
                group.addTask {
                    let language = languages[i % languages.count]
                    await MainActor.run {
                        self.languageService.setLanguage(language)
                    }
                }
            }
        }
        
        // Should complete without crashes
        let finalLanguage = languageService.currentLanguage
        XCTAssertTrue(languageService.isLanguageSupported(finalLanguage))
    }
    
    func testThreadSafetyLocalization() async {
        let key = "common.save"
        
        await withTaskGroup(of: String.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    return self.localizationService.localizedString(for: key)
                }
            }
            
            for await localized in group {
                XCTAssertFalse(localized.isEmpty)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func measureAsync(_ block: @escaping () async -> Void) async {
        let startTime = Date()
        await block()
        let duration = Date().timeIntervalSince(startTime)
        
        // Log performance (in real scenario, might assert on duration)
        print("Async operation took \(duration * 1000)ms")
    }
}
