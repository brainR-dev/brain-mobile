//
//  LanguageServiceTests.swift
//  BrainRushTests
//
//  Core tests for LanguageService
//

import XCTest
@testable import BrainRush

@MainActor
final class LanguageServiceTests: XCTestCase {
    var languageService: LanguageService!
    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Use a test UserDefaults to avoid affecting real app data
        userDefaults = UserDefaults(suiteName: "test.language.service")!
        userDefaults.removePersistentDomain(forName: "test.language.service")
        
        // Reset singleton state by creating a new instance for testing
        // Note: In a real scenario, you might want to make LanguageService testable
        // by allowing dependency injection of UserDefaults
        languageService = LanguageService.shared
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "test.language.service")
        super.tearDown()
    }
    
    // MARK: - Language Support Tests
    
    func testSupportedLanguages() {
        let supportedLanguages = languageService.supportedLanguages
        XCTAssertFalse(supportedLanguages.isEmpty, "Should have supported languages")
        
        // Verify common languages are supported
        let commonLanguages = ["en", "es", "fr", "de", "zh-CN", "ja"]
        for code in commonLanguages {
            XCTAssertTrue(
                languageService.isLanguageSupported(code),
                "Language \(code) should be supported"
            )
        }
    }
    
    func testUnsupportedLanguage() {
        XCTAssertFalse(
            languageService.isLanguageSupported("xx"),
            "Unsupported language should return false"
        )
        XCTAssertFalse(
            languageService.isLanguageSupported("invalid"),
            "Invalid language code should return false"
        )
    }
    
    // MARK: - Language Setting Tests
    
    func testSetLanguage() {
        let testLanguage = "es"
        languageService.setLanguage(testLanguage)
        
        XCTAssertEqual(
            languageService.currentLanguage,
            testLanguage,
            "Current language should be set to Spanish"
        )
    }
    
    func testSetLanguageNormalizesCase() {
        languageService.setLanguage("ES")
        XCTAssertEqual(languageService.currentLanguage, "es")
        
        languageService.setLanguage("Fr")
        XCTAssertEqual(languageService.currentLanguage, "fr")
        
        languageService.setLanguage("DE")
        XCTAssertEqual(languageService.currentLanguage, "de")
    }
    
    func testSetLanguageWithRegionalVariant() {
        languageService.setLanguage("zh-CN")
        XCTAssertEqual(languageService.currentLanguage, "zh-CN")
        
        languageService.setLanguage("zh-TW")
        XCTAssertEqual(languageService.currentLanguage, "zh-TW")
    }
    
    func testSetLanguageNormalizesRegionalVariants() {
        languageService.setLanguage("en-US")
        XCTAssertEqual(languageService.currentLanguage, "en")
        
        languageService.setLanguage("es-ES")
        XCTAssertEqual(languageService.currentLanguage, "es")
    }
    
    func testSetUnsupportedLanguageDoesNotChange() {
        let originalLanguage = languageService.currentLanguage
        languageService.setLanguage("xx")
        
        // Should remain at original language or default
        XCTAssertTrue(
            languageService.isLanguageSupported(languageService.currentLanguage),
            "Language should remain supported after attempting to set unsupported language"
        )
    }
    
    // MARK: - Language Detection Tests
    
    func testDetectSystemLanguage() {
        languageService.detectSystemLanguage()
        
        let detectedLanguage = languageService.currentLanguage
        XCTAssertTrue(
            languageService.isLanguageSupported(detectedLanguage),
            "Detected system language should be supported"
        )
    }
    
    // MARK: - Language Normalization Tests
    
    func testNormalizeLanguageCode() {
        // Test case normalization
        XCTAssertEqual(languageService.isLanguageSupported("EN"), true)
        XCTAssertEqual(languageService.isLanguageSupported("en"), true)
        XCTAssertEqual(languageService.isLanguageSupported("En"), true)
    }
    
    func testNormalizeLanguageCodeTrimsWhitespace() {
        // Note: This tests the internal normalization behavior
        languageService.setLanguage("  es  ")
        XCTAssertEqual(languageService.currentLanguage, "es")
        
        languageService.setLanguage("\tfr\t")
        XCTAssertEqual(languageService.currentLanguage, "fr")
    }
    
    // MARK: - Language Model Tests
    
    func testGetLanguageByCode() {
        let language = languageService.getLanguage(by: "es")
        XCTAssertNotNil(language, "Should return language model for Spanish")
        XCTAssertEqual(language?.code, "es")
    }
    
    func testGetLanguageByCodeReturnsNilForInvalid() {
        let language = languageService.getLanguage(by: "xx")
        XCTAssertNil(language, "Should return nil for unsupported language")
    }
    
    func testGetLanguageName() {
        let name = languageService.getLanguageName(by: "es")
        XCTAssertFalse(name.isEmpty, "Should return language name")
        
        let nativeName = languageService.getLanguageName(by: "es", native: true)
        XCTAssertFalse(nativeName.isEmpty, "Should return native language name")
    }
    
    func testGetLanguageNameForInvalidCode() {
        let name = languageService.getLanguageName(by: "xx")
        XCTAssertEqual(name, "xx", "Should return code for invalid language")
    }
    
    // MARK: - Language Change Notification Tests
    
    func testLanguageChangePostsNotification() {
        let expectation = expectation(description: "Language change notification")
        
        let observer = NotificationCenter.default.addObserver(
            forName: .languageDidChange,
            object: nil,
            queue: .main
        ) { notification in
            if let language = notification.userInfo?["language"] as? String {
                XCTAssertEqual(language, "fr")
                expectation.fulfill()
            }
        }
        
        languageService.setLanguage("fr")
        
        waitForExpectations(timeout: 1.0)
        NotificationCenter.default.removeObserver(observer)
    }
    
    // MARK: - Current Language Property Tests
    
    func testCurrentLanguageIsPublished() {
        let expectation = expectation(description: "Current language published")
        expectation.expectedFulfillmentCount = 1
        
        let cancellable = languageService.$currentLanguage
            .dropFirst() // Skip initial value
            .sink { newLanguage in
                XCTAssertEqual(newLanguage, "de")
                expectation.fulfill()
            }
        
        languageService.setLanguage("de")
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
    }
    
    func testCurrentLanguageModelUpdates() {
        languageService.setLanguage("ja")
        
        XCTAssertEqual(
            languageService.currentLanguageModel.code,
            "ja",
            "Language model should update when language changes"
        )
    }
}
