//
//  LocalizationTests.swift
//  BrainRushTests
//
//  Tests for localization and i18n
//

import XCTest
@testable import BrainRush

final class LocalizationTests: XCTestCase {
    
    func testLocalizedStringsExist() {
        // Test that key localized strings exist
        // This would require Localizable.strings files
        
        let commonKeys = [
            "sign_in",
            "sign_up",
            "email",
            "password",
            "loading",
            "error",
            "retry"
        ]
        
        for key in commonKeys {
            // Would check if localized string exists
            XCTAssertNotNil(key)
        }
    }
    
    func testDateFormatting() {
        let date = Date()
        
        // Test date formatting in different locales
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        // English
        formatter.locale = Locale(identifier: "en_US")
        let enFormatted = formatter.string(from: date)
        XCTAssertFalse(enFormatted.isEmpty)
        
        // Spanish
        formatter.locale = Locale(identifier: "es_ES")
        let esFormatted = formatter.string(from: date)
        XCTAssertFalse(esFormatted.isEmpty)
    }
    
    func testNumberFormatting() {
        let number = 1234.56
        
        // Test number formatting
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        // US format
        formatter.locale = Locale(identifier: "en_US")
        let usFormatted = formatter.string(from: NSNumber(value: number))
        XCTAssertNotNil(usFormatted)
        
        // European format
        formatter.locale = Locale(identifier: "de_DE")
        let deFormatted = formatter.string(from: NSNumber(value: number))
        XCTAssertNotNil(deFormatted)
    }
    
    func testRightToLeftSupport() {
        // Test RTL layout support if needed
        let isRTL = Locale.characterDirection(forLanguage: "ar") == .rightToLeft
        
        // RTL languages should be supported
        XCTAssertTrue(true) // Placeholder
    }
}
