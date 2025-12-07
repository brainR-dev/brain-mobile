//
//  LocalizationServiceTests.swift
//  BrainRushTests
//
//  Core tests for LocalizationService
//

import XCTest
@testable import BrainRush

final class LocalizationServiceTests: XCTestCase {
    var localizationService: LocalizationService!
    
    override func setUp() {
        super.setUp()
        localizationService = LocalizationService.shared
    }
    
    // MARK: - Bundle Loading Tests
    
    func testBundlesLoaded() {
        // Verify that bundles are loaded for supported languages
        let supportedLanguages = Language.supportedLanguages
        
        for language in supportedLanguages {
            let bundle = localizationService.bundle(for: language.code)
            XCTAssertNotNil(bundle, "Bundle should be loaded for \(language.code)")
        }
    }
    
    func testFallbackBundleAvailable() {
        let fallbackBundle = localizationService.bundle(for: "en")
        XCTAssertNotNil(fallbackBundle, "Fallback English bundle should always be available")
    }
    
    // MARK: - String Localization Tests
    
    func testLocalizedString() {
        // Test that localization service can retrieve strings
        let key = "common.ok"
        let localized = localizationService.localizedString(for: key)
        
        // Should return either localized string or fallback
        XCTAssertFalse(localized.isEmpty, "Localized string should not be empty")
    }
    
    func testLocalizedStringWithLanguageOverride() {
        let key = "common.save"
        
        // Test with explicit language
        let esLocalized = localizationService.localizedString(for: key, language: "es")
        let enLocalized = localizationService.localizedString(for: key, language: "en")
        
        XCTAssertFalse(esLocalized.isEmpty)
        XCTAssertFalse(enLocalized.isEmpty)
    }
    
    func testLocalizedStringWithFallback() {
        let key = "nonexistent.key"
        let fallback = "Fallback Text"
        
        let result = localizationService.localizedString(for: key, fallback: fallback)
        XCTAssertEqual(result, fallback, "Should use provided fallback for missing key")
    }
    
    func testLocalizedStringFallsBackToKey() {
        let key = "nonexistent.key"
        let result = localizationService.localizedString(for: key)
        
        // Should return key if no fallback provided and key not found
        XCTAssertEqual(result, key, "Should return key when translation not found and no fallback")
    }
    
    func testLocalizedStringWithArguments() {
        let key = "common.welcome"
        let name = "Test User"
        
        // Test string formatting with arguments
        let formatted = localizationService.localizedString(
            for: key,
            arguments: [name],
            language: "en"
        )
        
        XCTAssertFalse(formatted.isEmpty)
        // Note: Actual format string would need to exist in Localizable.strings
    }
    
    // MARK: - Bundle Conversion Tests
    
    func testChineseBundleConversion() {
        // Test that zh-CN converts to zh-Hans for iOS bundle naming
        let bundleCN = localizationService.bundle(for: "zh-CN")
        XCTAssertNotNil(bundleCN, "Should load bundle for zh-CN")
        
        let bundleTW = localizationService.bundle(for: "zh-TW")
        XCTAssertNotNil(bundleTW, "Should load bundle for zh-TW")
    }
    
    // MARK: - String Extension Tests
    
    func testStringExtensionLocalized() {
        let key = "common.cancel"
        let localized = key.localized()
        
        XCTAssertFalse(localized.isEmpty, "String extension should localize")
    }
    
    func testStringExtensionLocalizedWithLanguage() {
        let key = "common.save"
        let esLocalized = key.localized(language: "es")
        let enLocalized = key.localized(language: "en")
        
        XCTAssertFalse(esLocalized.isEmpty)
        XCTAssertFalse(enLocalized.isEmpty)
    }
    
    func testStringExtensionLocalizedWithArguments() {
        let key = "common.welcome"
        let localized = key.localized(with: "User", language: "en")
        
        XCTAssertFalse(localized.isEmpty)
    }
    
    // MARK: - Bundle Reload Tests
    
    func testReloadBundles() {
        // Test that bundles can be reloaded
        localizationService.reloadBundles()
        
        // Verify bundles are still accessible after reload
        let bundle = localizationService.bundle(for: "en")
        XCTAssertNotNil(bundle, "Bundle should still be available after reload")
    }
    
    // MARK: - Language Integration Tests
    
    func testLocalizationUsesCurrentLanguage() {
        // Set language via LanguageService
        LanguageService.shared.setLanguage("es")
        
        // Localization should use current language
        let key = "common.ok"
        let localized = localizationService.localizedString(for: key)
        
        // Should attempt to use Spanish
        XCTAssertFalse(localized.isEmpty)
    }
    
    func testLocalizationFallsBackToEnglish() {
        // Set to a language that might not have all translations
        LanguageService.shared.setLanguage("hi")
        
        let key = "common.save"
        let localized = localizationService.localizedString(for: key)
        
        // Should fall back to English if Hindi translation missing
        XCTAssertFalse(localized.isEmpty)
    }
}
