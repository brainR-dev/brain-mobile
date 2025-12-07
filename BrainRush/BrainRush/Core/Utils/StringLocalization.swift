//
//  StringLocalization.swift
//  BrainRush
//
//  String localization utilities and extensions
//

import Foundation

// MARK: - Localization Keys

struct LocalizedKey {
    // MARK: - Common
    static let ok = "common.ok"
    static let cancel = "common.cancel"
    static let save = "common.save"
    static let delete = "common.delete"
    static let edit = "common.edit"
    static let done = "common.done"
    static let next = "common.next"
    static let back = "common.back"
    static let close = "common.close"
    static let loading = "common.loading"
    static let error = "common.error"
    static let retry = "common.retry"
    static let search = "common.search"
    
    // MARK: - Auth
    static let signIn = "auth.sign_in"
    static let signUp = "auth.sign_up"
    static let signOut = "auth.sign_out"
    static let email = "auth.email"
    static let password = "auth.password"
    static let forgotPassword = "auth.forgot_password"
    static let createAccount = "auth.create_account"
    static let alreadyHaveAccount = "auth.already_have_account"
    
    // MARK: - Dashboard
    static let dashboard = "dashboard.title"
    static let continueLearning = "dashboard.continue_learning"
    static let myCourses = "dashboard.my_courses"
    static let recommendations = "dashboard.recommendations"
    
    // MARK: - Courses
    static let courses = "courses.title"
    static let enroll = "courses.enroll"
    static let enrolled = "courses.enrolled"
    static let lessons = "courses.lessons"
    
    // MARK: - Settings
    static let settings = "settings.title"
    static let language = "settings.language"
    static let selectLanguage = "settings.select_language"
    static let profile = "settings.profile"
    
    // MARK: - Errors
    static let networkError = "error.network"
    static let serverError = "error.server"
    static let unknownError = "error.unknown"
}

// MARK: - Localization Helper Functions

struct LocalizationHelper {
    static func localized(_ key: String, language: String? = nil, fallback: String? = nil) -> String {
        return LocalizationService.shared.localizedString(for: key, language: language, fallback: fallback)
    }
    
    static func localized(_ key: String, arguments: [CVarArg], language: String? = nil) -> String {
        return LocalizationService.shared.localizedString(for: key, arguments: arguments, language: language)
    }
    
    static func localized(_ key: String, arguments: CVarArg..., language: String? = nil) -> String {
        return LocalizationService.shared.localizedString(for: key, arguments: arguments, language: language)
    }
}

