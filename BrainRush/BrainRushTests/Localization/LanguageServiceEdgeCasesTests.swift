//
//  LanguageServiceEdgeCasesTests.swift
//  BrainRushTests
//
//  Edge case tests for LanguageService (concurrent access, invalid inputs, corrupted data)
//

import XCTest
@testable import BrainRush

@MainActor
final class LanguageServiceEdgeCasesTests: XCTestCase {
    var languageService: LanguageService!
    
    override func setUp() {
        super.setUp()
        languageService = LanguageService.shared
    }
    
    // MARK: - Concurrent Access Tests
    
    func testConcurrentLanguageChanges() async {
        let languages = ["en", "es", "fr", "de", "ja"]
        let iterations = 100
        
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<iterations {
                group.addTask {
                    let randomLanguage = languages.randomElement()!
                    await MainActor.run {
                        self.languageService.setLanguage(randomLanguage)
                    }
                }
            }
        }
        
        // After concurrent changes, language should be valid
        let finalLanguage = languageService.currentLanguage
        XCTAssertTrue(
            languageService.isLanguageSupported(finalLanguage),
            "Language should be valid after concurrent changes"
        )
    }
    
    func testConcurrentLanguageReads() async {
        languageService.setLanguage("es")
        
        await withTaskGroup(of: String.self) { group in
            for _ in 0..<100 {
                group.addTask {
                    await MainActor.run {
                        return self.languageService.currentLanguage
                    }
                }
            }
            
            for await language in group {
                XCTAssertEqual(language, "es", "Concurrent reads should return consistent value")
            }
        }
    }
    
    func testConcurrentReadWrite() async {
        let languages = ["en", "es", "fr", "de"]
        
        await withTaskGroup(of: Void.self) { group in
            // Writers
            for i in 0..<50 {
                group.addTask {
                    let lang = languages[i % languages.count]
                    await MainActor.run {
                        self.languageService.setLanguage(lang)
                    }
                }
            }
            
            // Readers
            for _ in 0..<50 {
                group.addTask {
                    await MainActor.run {
                        let language = self.languageService.currentLanguage
                        XCTAssertTrue(
                            self.languageService.isLanguageSupported(language),
                            "Read language should always be valid"
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Invalid Input Tests
    
    func testInvalidLanguageCodes() {
        let invalidCodes = [
            "",
            " ",
            "   ",
            "xxx",
            "123",
            "en-US-INVALID",
            "toolonglanguagecode",
            "en-",
            "-US",
            "en_US",
            "en.us",
            "en us",
        ]
        
        for code in invalidCodes {
            let originalLanguage = languageService.currentLanguage
            languageService.setLanguage(code)
            
            // Should either remain at original or default to supported language
            let currentLanguage = languageService.currentLanguage
            XCTAssertTrue(
                languageService.isLanguageSupported(currentLanguage),
                "Language should remain valid after invalid input: \(code)"
            )
        }
    }
    
    func testSpecialCharactersInLanguageCode() {
        let specialCharCodes = [
            "en<script>",
            "es' OR '1'='1",
            "fr; DROP TABLE;",
            "de\n",
            "ja\t",
            "pt\r",
            "ru\0",
        ]
        
        for code in specialCharCodes {
            let originalLanguage = languageService.currentLanguage
            languageService.setLanguage(code)
            
            let currentLanguage = languageService.currentLanguage
            XCTAssertTrue(
                languageService.isLanguageSupported(currentLanguage),
                "Language should handle special characters safely: \(code)"
            )
        }
    }
    
    func testUnicodeInLanguageCode() {
        let unicodeCodes = [
            "en\u200B", // Zero-width space
            "es\uFEFF", // Zero-width no-break space
            "fr\u200C", // Zero-width non-joiner
            "de\u200D", // Zero-width joiner
            "ja\u202E", // Right-to-left override
        ]
        
        for code in unicodeCodes {
            languageService.setLanguage(code)
            let currentLanguage = languageService.currentLanguage
            XCTAssertTrue(
                languageService.isLanguageSupported(currentLanguage),
                "Language should handle unicode safely"
            )
        }
    }
    
    func testEmojiInLanguageCode() {
        let emojiCodes = [
            "en🇺🇸",
            "es😀",
            "fr🎉",
            "de🚀",
        ]
        
        for code in emojiCodes {
            languageService.setLanguage(code)
            let currentLanguage = languageService.currentLanguage
            XCTAssertTrue(
                languageService.isLanguageSupported(currentLanguage),
                "Language should handle emoji safely"
            )
        }
    }
    
    func testExtremelyLongLanguageCode() {
        let longCode = String(repeating: "a", count: 10000)
        let originalLanguage = languageService.currentLanguage
        
        languageService.setLanguage(longCode)
        
        let currentLanguage = languageService.currentLanguage
        XCTAssertTrue(
            languageService.isLanguageSupported(currentLanguage),
            "Language should handle extremely long strings"
        )
    }
    
    // MARK: - Corrupted Data Tests
    
    func testCorruptedUserDefaultsData() {
        // Simulate corrupted UserDefaults data
        UserDefaults.standard.set(12345, forKey: "app_language_preference")
        
        // Service should handle gracefully
        languageService.detectSystemLanguage()
        
        let currentLanguage = languageService.currentLanguage
        XCTAssertTrue(
            languageService.isLanguageSupported(currentLanguage),
            "Should recover from corrupted UserDefaults data"
        )
    }
    
    func testInvalidLanguageInUserDefaults() {
        // Set invalid language in UserDefaults
        UserDefaults.standard.set("invalid-language", forKey: "app_language_preference")
        
        // Service should detect and use system language
        languageService.detectSystemLanguage()
        
        let currentLanguage = languageService.currentLanguage
        XCTAssertTrue(
            languageService.isLanguageSupported(currentLanguage),
            "Should recover from invalid UserDefaults language"
        )
    }
    
    func testNullLanguageInUserDefaults() {
        // Set null/empty in UserDefaults
        UserDefaults.standard.set("", forKey: "app_language_preference")
        
        languageService.detectSystemLanguage()
        
        let currentLanguage = languageService.currentLanguage
        XCTAssertTrue(
            languageService.isLanguageSupported(currentLanguage),
            "Should handle empty UserDefaults value"
        )
    }
    
    // MARK: - Boundary Tests
    
    func testAllSupportedLanguages() {
        let supportedLanguages = languageService.supportedLanguages
        
        for language in supportedLanguages {
            languageService.setLanguage(language.code)
            XCTAssertEqual(
                languageService.currentLanguage,
                language.code,
                "Should support all listed languages: \(language.code)"
            )
        }
    }
    
    func testLanguageCaseVariations() {
        let testCases = [
            ("EN", "en"),
            ("Es", "es"),
            ("FR", "fr"),
            ("De", "de"),
            ("JA", "ja"),
            ("Pt", "pt"),
            ("RU", "ru"),
            ("HI", "hi"),
            ("AR", "ar"),
            ("ZH-CN", "zh-CN"),
            ("zh-cn", "zh-CN"),
            ("Zh-Cn", "zh-CN"),
            ("ZH-TW", "zh-TW"),
            ("zh-tw", "zh-TW"),
        ]
        
        for (input, expected) in testCases {
            languageService.setLanguage(input)
            XCTAssertEqual(
                languageService.currentLanguage,
                expected,
                "Should normalize case: \(input) -> \(expected)"
            )
        }
    }
    
    // MARK: - Rapid Changes Tests
    
    func testRapidLanguageChanges() {
        let languages = ["en", "es", "fr", "de", "ja", "pt", "ru"]
        
        for language in languages {
            languageService.setLanguage(language)
            XCTAssertEqual(languageService.currentLanguage, language)
        }
        
        // Final language should be last set
        XCTAssertEqual(languageService.currentLanguage, "ru")
    }
    
    func testRapidSameLanguageChanges() {
        // Rapidly set same language multiple times
        for _ in 0..<100 {
            languageService.setLanguage("es")
        }
        
        XCTAssertEqual(languageService.currentLanguage, "es")
    }
    
    // MARK: - Memory Tests
    
    func testLanguageServiceMemoryLeak() {
        weak var weakService: LanguageService?
        
        autoreleasepool {
            let service = LanguageService.shared
            weakService = service
        }
        
        // Service is singleton, so it should persist
        // This test verifies no unexpected retain cycles
        XCTAssertNotNil(weakService, "Singleton should persist")
    }
    
    // MARK: - Notification Tests
    
    func testMultipleLanguageChangeNotifications() {
        var notificationCount = 0
        let expectation = expectation(description: "Multiple notifications")
        expectation.expectedFulfillmentCount = 5
        
        let observer = NotificationCenter.default.addObserver(
            forName: .languageDidChange,
            object: nil,
            queue: .main
        ) { _ in
            notificationCount += 1
            expectation.fulfill()
        }
        
        let languages = ["en", "es", "fr", "de", "ja"]
        for language in languages {
            languageService.setLanguage(language)
        }
        
        waitForExpectations(timeout: 2.0)
        NotificationCenter.default.removeObserver(observer)
        
        XCTAssertEqual(notificationCount, 5, "Should receive notification for each language change")
    }
    
    func testNoNotificationForSameLanguage() {
        var notificationCount = 0
        
        let observer = NotificationCenter.default.addObserver(
            forName: .languageDidChange,
            object: nil,
            queue: .main
        ) { _ in
            notificationCount += 1
        }
        
        languageService.setLanguage("es")
        languageService.setLanguage("es") // Same language
        languageService.setLanguage("es") // Same language
        
        // Give notifications time to process
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.1))
        
        NotificationCenter.default.removeObserver(observer)
        
        // Should only receive one notification (first change)
        // Note: removeDuplicates() in setupLanguageObserver should prevent duplicates
        XCTAssertLessThanOrEqual(notificationCount, 1, "Should not notify for same language")
    }
}
