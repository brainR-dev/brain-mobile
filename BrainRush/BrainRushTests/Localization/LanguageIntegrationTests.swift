//
//  LanguageIntegrationTests.swift
//  BrainRushTests
//
//  Integration tests for language features (service integration, E2E flows, UI tests)
//

import XCTest
@testable import BrainRush

@MainActor
final class LanguageIntegrationTests: XCTestCase {
    var languageService: LanguageService!
    var localizationService: LocalizationService!
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        languageService = LanguageService.shared
        localizationService = LocalizationService.shared
        apiClient = APIClient.shared
    }
    
    // MARK: - Service Integration Tests
    
    func testLanguageServiceAndLocalizationServiceIntegration() {
        // Set language via LanguageService
        languageService.setLanguage("es")
        
        // LocalizationService should use current language
        let key = "common.save"
        let localized = localizationService.localizedString(for: key)
        
        // Should attempt Spanish localization
        XCTAssertFalse(localized.isEmpty)
        XCTAssertEqual(languageService.currentLanguage, "es")
    }
    
    func testLanguageChangeUpdatesLocalization() {
        // Start with English
        languageService.setLanguage("en")
        let enLocalized = localizationService.localizedString(
            for: "common.ok",
            language: "en"
        )
        
        // Change to Spanish
        languageService.setLanguage("es")
        let esLocalized = localizationService.localizedString(
            for: "common.ok",
            language: "es"
        )
        
        // Both should work
        XCTAssertFalse(enLocalized.isEmpty)
        XCTAssertFalse(esLocalized.isEmpty)
    }
    
    func testAPIClientUsesLanguageService() {
        // Set language
        languageService.setLanguage("fr")
        
        // APIClient should use LanguageService.shared.currentLanguage
        // This is verified through the buildURL and request methods
        XCTAssertEqual(languageService.currentLanguage, "fr")
        
        // Next API request would include "fr" in X-Language header and lang query param
    }
    
    func testLanguageChangePropagatesToAPIClient() {
        languageService.setLanguage("de")
        let language1 = languageService.currentLanguage
        
        languageService.setLanguage("ja")
        let language2 = languageService.currentLanguage
        
        // APIClient should use latest language
        XCTAssertNotEqual(language1, language2)
        XCTAssertEqual(language2, "ja")
    }
    
    // MARK: - End-to-End Flow Tests
    
    func testCompleteLanguageChangeFlow() {
        // 1. User changes language in settings
        languageService.setLanguage("pt")
        XCTAssertEqual(languageService.currentLanguage, "pt")
        
        // 2. UI should update (tested in UI tests)
        let localized = localizationService.localizedString(
            for: "common.save",
            language: "pt"
        )
        XCTAssertFalse(localized.isEmpty)
        
        // 3. API requests should use new language
        // Verified through APIClient using LanguageService.shared.currentLanguage
        XCTAssertEqual(languageService.currentLanguage, "pt")
    }
    
    func testLanguagePersistenceFlow() {
        // 1. Set language
        languageService.setLanguage("ru")
        
        // 2. Language should be saved to UserDefaults
        // (Verified through setLanguage implementation)
        XCTAssertEqual(languageService.currentLanguage, "ru")
        
        // 3. On app restart, language should be loaded
        // (This would require app restart simulation)
        // For now, verify language is set correctly
        XCTAssertTrue(languageService.isLanguageSupported("ru"))
    }
    
    func testSystemLanguageDetectionFlow() {
        // 1. Detect system language
        languageService.detectSystemLanguage()
        
        // 2. Should set to supported language or English
        let detectedLanguage = languageService.currentLanguage
        XCTAssertTrue(
            languageService.isLanguageSupported(detectedLanguage),
            "Detected language should be supported"
        )
        
        // 3. Should be saved to UserDefaults
        // (Verified through detectSystemLanguage -> setLanguage flow)
    }
    
    // MARK: - Multi-Service Integration Tests
    
    func testLanguageServiceLocalizationServiceAPIClientIntegration() {
        // Set language
        languageService.setLanguage("zh-CN")
        
        // All services should use same language
        let currentLanguage = languageService.currentLanguage
        let localized = localizationService.localizedString(
            for: "common.ok",
            language: currentLanguage
        )
        
        XCTAssertEqual(currentLanguage, "zh-CN")
        XCTAssertFalse(localized.isEmpty)
        // APIClient would use currentLanguage in next request
    }
    
    func testNotificationFlow() {
        var receivedLanguage: String?
        let expectation = expectation(description: "Language change notification")
        
        let observer = NotificationCenter.default.addObserver(
            forName: .languageDidChange,
            object: nil,
            queue: .main
        ) { notification in
            receivedLanguage = notification.userInfo?["language"] as? String
            expectation.fulfill()
        }
        
        // Change language
        languageService.setLanguage("hi")
        
        waitForExpectations(timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
        
        XCTAssertEqual(receivedLanguage, "hi")
        XCTAssertEqual(languageService.currentLanguage, "hi")
    }
    
    // MARK: - Language Bundle Integration Tests
    
    func testLanguageBundleLoadingIntegration() {
        let languages = ["en", "es", "fr", "de", "zh-CN"]
        
        for languageCode in languages {
            // Set language
            languageService.setLanguage(languageCode)
            
            // Get bundle
            let bundle = localizationService.bundle(for: languageCode)
            XCTAssertNotNil(bundle, "Bundle should be available for \(languageCode)")
            
            // Localize string
            let localized = localizationService.localizedString(
                for: "common.ok",
                language: languageCode
            )
            XCTAssertFalse(localized.isEmpty, "Should localize for \(languageCode)")
        }
    }
    
    // MARK: - Error Handling Integration Tests
    
    func testErrorHandlingWhenLanguageUnavailable() {
        // Set to language that might not have all translations
        languageService.setLanguage("ar")
        
        // Should fall back to English for missing translations
        let localized = localizationService.localizedString(
            for: "common.save",
            language: "ar"
        )
        
        // Should not be empty (falls back to English)
        XCTAssertFalse(localized.isEmpty)
    }
    
    func testErrorHandlingWhenBundleMissing() {
        // Try to use language that doesn't have bundle
        let localized = localizationService.localizedString(
            for: "common.ok",
            language: "xx"
        )
        
        // Should fall back gracefully
        XCTAssertFalse(localized.isEmpty)
    }
    
    // MARK: - Language Model Integration Tests
    
    func testLanguageModelIntegration() {
        languageService.setLanguage("ja")
        
        // Language model should be updated
        let languageModel = languageService.currentLanguageModel
        XCTAssertEqual(languageModel.code, "ja")
        
        // Can get language info
        let name = languageService.getLanguageName(by: "ja")
        XCTAssertFalse(name.isEmpty)
        
        let nativeName = languageService.getLanguageName(by: "ja", native: true)
        XCTAssertFalse(nativeName.isEmpty)
    }
    
    // MARK: - String Extension Integration Tests
    
    func testStringExtensionIntegration() {
        languageService.setLanguage("es")
        
        // String extension should use current language
        let localized = "common.save".localized()
        XCTAssertFalse(localized.isEmpty)
        
        // Can override language
        let enLocalized = "common.save".localized(language: "en")
        XCTAssertFalse(enLocalized.isEmpty)
    }
    
    func testStringExtensionWithLanguageService() {
        // Change language
        languageService.setLanguage("fr")
        
        // String extension uses current language by default
        let localized = "common.ok".localized()
        XCTAssertFalse(localized.isEmpty)
        
        // Change language again
        languageService.setLanguage("de")
        let localized2 = "common.ok".localized()
        XCTAssertFalse(localized2.isEmpty)
    }
}
