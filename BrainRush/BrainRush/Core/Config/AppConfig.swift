//
//  AppConfig.swift
//  BrainRush
//
//  App configuration and constants
//

import Foundation

struct AppConfig {
    static let apiBaseURL = "https://brainrash.com/api"
    static let bundleID = "com.brainrash.BrainRush"
    static let appName = "BrainRush"
    
    // Supabase Configuration
    static var supabaseURL: String {
        if let url = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String {
            return url
        }
        return "https://your-project.supabase.co"
    }
    
    static var supabaseAnonKey: String {
        if let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String {
            return key
        }
        return "your-anon-key-here"
    }
    
    // PostHog Configuration
    static var posthogAPIKey: String? {
        if let key = Bundle.main.infoDictionary?["POSTHOG_API_KEY"] as? String, !key.isEmpty {
            return key
        }
        // Try environment variable as fallback
        return ProcessInfo.processInfo.environment["POSTHOG_API_KEY"]
    }
    
    static var posthogHost: String {
        if let host = Bundle.main.infoDictionary?["POSTHOG_HOST"] as? String, !host.isEmpty {
            return host
        }
        // Default PostHog cloud host
        return "https://us.i.posthog.com"
    }
    
    // App Version
    static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    // Build Number
    static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}
