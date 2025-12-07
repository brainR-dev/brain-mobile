//
//  LocalizationService.swift
//  BrainRush
//
//  Service for loading and managing localized strings
//

import Foundation

class LocalizationService {
    static let shared = LocalizationService()
    
    private var bundles: [String: Bundle] = [:]
    private let fallbackLanguage = "en"
    
    private init() {
        loadBundles()
    }
    
    // MARK: - Bundle Loading
    
    private func loadBundles() {
        // Load bundles for all supported languages
        for language in Language.supportedLanguages {
            if let bundle = loadBundle(for: language.code) {
                bundles[language.code] = bundle
            }
        }
        
        // Ensure fallback bundle is loaded
        if bundles[fallbackLanguage] == nil {
            bundles[fallbackLanguage] = Bundle.main
        }
    }
    
    private func loadBundle(for languageCode: String) -> Bundle? {
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            // Try alternative naming conventions
            let alternativeCode = convertLanguageCodeToBundleName(languageCode)
            guard let altPath = Bundle.main.path(forResource: alternativeCode, ofType: "lproj"),
                  let altBundle = Bundle(path: altPath) else {
                return nil
            }
            return altBundle
        }
        return bundle
    }
    
    private func convertLanguageCodeToBundleName(_ code: String) -> String {
        // Convert language codes to iOS bundle naming conventions
        switch code {
        case "zh-CN":
            return "zh-Hans"
        case "zh-TW":
            return "zh-Hant"
        default:
            return code
        }
    }
    
    // MARK: - String Localization
    
    func localizedString(for key: String, language: String? = nil, fallback: String? = nil) -> String {
        let targetLanguage = language ?? LanguageService.shared.currentLanguage
        
        // Try target language bundle
        if let bundle = bundles[targetLanguage],
           let localizedString = bundle.localizedString(forKey: key, value: nil, table: nil),
           localizedString != key {
            return localizedString
        }
        
        // Try fallback language bundle
        if targetLanguage != fallbackLanguage,
           let fallbackBundle = bundles[fallbackLanguage],
           let localizedString = fallbackBundle.localizedString(forKey: key, value: nil, table: nil),
           localizedString != key {
            return localizedString
        }
        
        // Use provided fallback or key name
        return fallback ?? key
    }
    
    func localizedString(for key: String, arguments: [CVarArg], language: String? = nil) -> String {
        let format = localizedString(for: key, language: language)
        return String(format: format, arguments: arguments)
    }
    
    // MARK: - Bundle Access
    
    func bundle(for languageCode: String) -> Bundle {
        return bundles[languageCode] ?? bundles[fallbackLanguage] ?? Bundle.main
    }
    
    // MARK: - Utility Methods
    
    func reloadBundles() {
        bundles.removeAll()
        loadBundles()
    }
}

// MARK: - String Extension for Easy Localization

extension String {
    func localized(language: String? = nil, fallback: String? = nil) -> String {
        return LocalizationService.shared.localizedString(for: self, language: language, fallback: fallback)
    }
    
    func localized(with arguments: CVarArg..., language: String? = nil) -> String {
        return LocalizationService.shared.localizedString(for: self, arguments: arguments, language: language)
    }
    
    func localized(with arguments: [CVarArg], language: String? = nil) -> String {
        return LocalizationService.shared.localizedString(for: self, arguments: arguments, language: language)
    }
}

