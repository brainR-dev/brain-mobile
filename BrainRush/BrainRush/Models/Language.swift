//
//  Language.swift
//  BrainRush
//
//  Language model for multilingual support
//

import Foundation

struct Language: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let code: String
    let name: String
    let nativeName: String
    let flag: String?
    
    init(id: String? = nil, code: String, name: String, nativeName: String, flag: String? = nil) {
        self.id = id ?? code
        self.code = code
        self.name = name
        self.nativeName = nativeName
        self.flag = flag
    }
    
    static let supportedLanguages: [Language] = [
        Language(code: "en", name: "English", nativeName: "English", flag: "🇺🇸"),
        Language(code: "es", name: "Spanish", nativeName: "Español", flag: "🇪🇸"),
        Language(code: "zh-CN", name: "Chinese Simplified", nativeName: "简体中文", flag: "🇨🇳"),
        Language(code: "zh-TW", name: "Chinese Traditional", nativeName: "繁體中文", flag: "🇹🇼"),
        Language(code: "hi", name: "Hindi", nativeName: "हिन्दी", flag: "🇮🇳"),
        Language(code: "ar", name: "Arabic", nativeName: "العربية", flag: "🇸🇦"),
        Language(code: "pt", name: "Portuguese", nativeName: "Português", flag: "🇵🇹"),
        Language(code: "ru", name: "Russian", nativeName: "Русский", flag: "🇷🇺"),
        Language(code: "ja", name: "Japanese", nativeName: "日本語", flag: "🇯🇵"),
        Language(code: "fr", name: "French", nativeName: "Français", flag: "🇫🇷"),
        Language(code: "de", name: "German", nativeName: "Deutsch", flag: "🇩🇪")
    ]
    
    static let `default` = supportedLanguages.first { $0.code == "en" }!
    
    static func language(for code: String) -> Language? {
        return supportedLanguages.first { $0.code.lowercased() == code.lowercased() }
    }
}

