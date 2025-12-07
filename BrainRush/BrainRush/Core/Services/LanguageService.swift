//
//  LanguageService.swift
//  BrainRush
//
//  Language service for managing app language preferences
//

import Foundation
import Combine

@MainActor
class LanguageService: ObservableObject {
    static let shared = LanguageService()
    
    @Published var currentLanguage: String = "en"
    @Published var currentLanguageModel: Language = Language.default
    
    private let userDefaultsKey = "app_language_preference"
    private var cancellables = Set<AnyCancellable>()
    
    var supportedLanguages: [Language] {
        return Language.supportedLanguages
    }
    
    private init() {
        loadLanguagePreference()
        setupLanguageObserver()
    }
    
    // MARK: - Language Preference Management
    
    private func loadLanguagePreference() {
        if let savedLanguage = UserDefaults.standard.string(forKey: userDefaultsKey) {
            if isLanguageSupported(savedLanguage) {
                currentLanguage = savedLanguage
                currentLanguageModel = Language.language(for: savedLanguage) ?? Language.default
            } else {
                // Invalid saved language, detect system language
                detectSystemLanguage()
            }
        } else {
            // No saved preference, detect system language
            detectSystemLanguage()
        }
    }
    
    func setLanguage(_ code: String) {
        guard isLanguageSupported(code) else {
            Logger.shared.warning("Attempted to set unsupported language: \(code)")
            return
        }
        
        let normalizedCode = normalizeLanguageCode(code)
        currentLanguage = normalizedCode
        currentLanguageModel = Language.language(for: normalizedCode) ?? Language.default
        
        // Save to UserDefaults
        UserDefaults.standard.set(normalizedCode, forKey: userDefaultsKey)
        
        Logger.shared.info("Language changed to: \(normalizedCode)")
        
        // Track language change in analytics
        AnalyticsService.shared.track("language_changed", properties: [
            "language": normalizedCode,
            "language_name": currentLanguageModel.name
        ])
    }
    
    // MARK: - System Language Detection
    
    func detectSystemLanguage() {
        let systemLanguage = getSystemLanguage()
        
        if isLanguageSupported(systemLanguage) {
            setLanguage(systemLanguage)
        } else {
            // Fallback to English if system language not supported
            setLanguage("en")
        }
    }
    
    private func getSystemLanguage() -> String {
        // Get preferred language from system
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        
        // Extract language code (e.g., "en-US" -> "en", "zh-Hans" -> "zh-CN")
        let languageCode = preferredLanguage.components(separatedBy: "-").first ?? "en"
        
        // Handle special cases for Chinese
        if preferredLanguage.contains("zh-Hans") || preferredLanguage.contains("zh-CN") {
            return "zh-CN"
        } else if preferredLanguage.contains("zh-Hant") || preferredLanguage.contains("zh-TW") {
            return "zh-TW"
        }
        
        return languageCode.lowercased()
    }
    
    // MARK: - Language Validation
    
    func isLanguageSupported(_ code: String) -> Bool {
        let normalizedCode = normalizeLanguageCode(code)
        return Language.supportedLanguages.contains { $0.code.lowercased() == normalizedCode.lowercased() }
    }
    
    private func normalizeLanguageCode(_ code: String) -> String {
        // Trim whitespace
        let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Handle case variations
        let parts = trimmed.split(separator: "-")
        if parts.count == 2 {
            // Language-region format (e.g., "zh-CN")
            return "\(parts[0].lowercased())-\(parts[1].uppercased())"
        } else {
            // Simple language code (e.g., "en")
            return trimmed.lowercased()
        }
    }
    
    // MARK: - Observers
    
    private func setupLanguageObserver() {
        $currentLanguage
            .removeDuplicates()
            .sink { [weak self] newLanguage in
                guard let self = self else { return }
                // Notify other services if needed
                NotificationCenter.default.post(
                    name: .languageDidChange,
                    object: nil,
                    userInfo: ["language": newLanguage]
                )
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Language Info
    
    func getLanguage(by code: String) -> Language? {
        return Language.language(for: code)
    }
    
    func getLanguageName(by code: String, native: Bool = false) -> String {
        if let language = Language.language(for: code) {
            return native ? language.nativeName : language.name
        }
        return code
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let languageDidChange = Notification.Name("languageDidChange")
}

