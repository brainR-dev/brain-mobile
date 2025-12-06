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
    // TODO: Add these to Info.plist or a secure configuration
    // For now, using placeholder values that should be replaced with actual Supabase credentials
    static var supabaseURL: String {
        // This should come from Info.plist or environment
        if let url = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String {
            return url
        }
        // Placeholder - should be replaced with actual Supabase URL
        return "https://your-project.supabase.co"
    }
    
    static var supabaseAnonKey: String {
        if let key = Bundle.main.infoDictionary?["SUPABASE_ANON_KEY"] as? String {
            return key
        }
        // Placeholder - should be replaced with actual Supabase anon key
        return "your-anon-key-here"
    }
}
