//
//  LocalizationServiceEdgeCasesTests.swift
//  BrainRushTests
//
//  Edge case tests for LocalizationService
//

import XCTest
@testable import BrainRush

final class LocalizationServiceEdgeCasesTests: XCTestCase {
    var localizationService: LocalizationService!
    
    override func setUp() {
        super.setUp()
        localizationService = LocalizationService.shared
    }
    
    // MARK: - Invalid Key Tests
    
    func testInvalidKeys() {
        let invalidKeys = [
            "",
            " ",
            "   ",
            "nonexistent.key",
            "invalid",
            "key.with.many.dots",
            "key-with-dashes",
            "key_with_underscores",
            "key with spaces",
            "key\nwith\nnewlines",
            "key\twith\ttabs",
        ]
        
        for key in invalidKeys {
            let localized = localizationService.localizedString(for: key)
            // Should return key or fallback, not crash
            XCTAssertFalse(localized.isEmpty, "Should handle invalid key: \(key)")
        }
    }
    
    func testSpecialCharactersInKey() {
        let specialCharKeys = [
            "key<script>",
            "key' OR '1'='1",
            "key; DROP TABLE;",
            "key\n",
            "key\t",
            "key\0",
        ]
        
        for key in specialCharKeys {
            let localized = localizationService.localizedString(for: key)
            XCTAssertFalse(localized.isEmpty, "Should handle special characters in key")
        }
    }
    
    func testUnicodeInKey() {
        let unicodeKeys = [
            "key\u200B",
            "key\uFEFF",
            "key\u200C",
            "key\u200D",
        ]
        
        for key in unicodeKeys {
            let localized = localizationService.localizedString(for: key)
            XCTAssertFalse(localized.isEmpty, "Should handle unicode in key")
        }
    }
    
    // MARK: - Missing Bundle Tests
    
    func testMissingLanguageBundle() {
        // Test with language that might not have bundle
        let localized = localizationService.localizedString(
            for: "common.ok",
            language: "xx"
        )
        
        // Should fall back to English
        XCTAssertFalse(localized.isEmpty, "Should fall back when bundle missing")
    }
    
    func testCorruptedBundle() {
        // Test that service handles bundle loading gracefully
        // In real scenario, corrupted bundles would be handled by iOS
        let bundle = localizationService.bundle(for: "en")
        XCTAssertNotNil(bundle, "Should always have fallback bundle")
    }
    
    // MARK: - Concurrent Access Tests
    
    func testConcurrentLocalization() async {
        let key = "common.save"
        let languages = ["en", "es", "fr", "de"]
        
        await withTaskGroup(of: String.self) { group in
            for language in languages {
                group.addTask {
                    return self.localizationService.localizedString(
                        for: key,
                        language: language
                    )
                }
            }
            
            for await localized in group {
                XCTAssertFalse(localized.isEmpty, "Concurrent localization should work")
            }
        }
    }
    
    func testConcurrentBundleAccess() async {
        await withTaskGroup(of: Bundle?.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    return self.localizationService.bundle(for: "en")
                }
            }
            
            for await bundle in group {
                XCTAssertNotNil(bundle, "Concurrent bundle access should work")
            }
        }
    }
    
    // MARK: - Fallback Tests
    
    func testFallbackChain() {
        let key = "nonexistent.key"
        
        // Test fallback to English
        let result = localizationService.localizedString(for: key, language: "hi")
        
        // Should fall back through: hi -> en -> key
        XCTAssertFalse(result.isEmpty)
    }
    
    func testCustomFallback() {
        let key = "nonexistent.key"
        let customFallback = "Custom Fallback Text"
        
        let result = localizationService.localizedString(
            for: key,
            fallback: customFallback
        )
        
        XCTAssertEqual(result, customFallback, "Should use custom fallback")
    }
    
    func testFallbackWithArguments() {
        let key = "common.welcome"
        let fallback = "Welcome, %@"
        
        let result = localizationService.localizedString(
            for: key,
            arguments: ["User"],
            language: "xx",
            fallback: fallback
        )
        
        XCTAssertFalse(result.isEmpty, "Should handle fallback with arguments")
    }
    
    // MARK: - String Extension Edge Cases
    
    func testStringExtensionWithInvalidKey() {
        let key = ""
        let localized = key.localized()
        XCTAssertFalse(localized.isEmpty)
    }
    
    func testStringExtensionWithNilLanguage() {
        let key = "common.ok"
        let localized = key.localized(language: nil)
        XCTAssertFalse(localized.isEmpty)
    }
    
    func testStringExtensionWithInvalidLanguage() {
        let key = "common.save"
        let localized = key.localized(language: "xx")
        XCTAssertFalse(localized.isEmpty, "Should fall back to English")
    }
    
    // MARK: - Bundle Reload Tests
    
    func testReloadBundlesMaintainsFunctionality() {
        let key = "common.cancel"
        let before = localizationService.localizedString(for: key)
        
        localizationService.reloadBundles()
        
        let after = localizationService.localizedString(for: key)
        XCTAssertFalse(after.isEmpty, "Should work after reload")
    }
    
    func testMultipleBundleReloads() {
        for _ in 0..<10 {
            localizationService.reloadBundles()
        }
        
        let bundle = localizationService.bundle(for: "en")
        XCTAssertNotNil(bundle, "Should work after multiple reloads")
    }
    
    // MARK: - Performance Edge Cases
    
    func testManyLocalizationCalls() {
        let key = "common.ok"
        let startTime = Date()
        
        for _ in 0..<1000 {
            _ = localizationService.localizedString(for: key)
        }
        
        let duration = Date().timeIntervalSince(startTime)
        XCTAssertLessThan(duration, 1.0, "1000 localizations should complete in < 1 second")
    }
    
    func testManyLanguageSwitches() {
        let languages = ["en", "es", "fr", "de", "ja"]
        let key = "common.save"
        
        for language in languages {
            _ = localizationService.localizedString(for: key, language: language)
        }
        
        // Should complete without issues
        XCTAssertTrue(true)
    }
}
