//
//  Formatters.swift
//  BrainRush
//
//  Number and text formatting utilities
//

import Foundation

struct Formatters {
    static let number: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
    
    static let percentage: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    static func formatDuration(minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
    }
    
    static func formatXP(_ xp: Int) -> String {
        if xp >= 1_000_000 {
            return String(format: "%.1fM", Double(xp) / 1_000_000.0)
        } else if xp >= 1_000 {
            return String(format: "%.1fK", Double(xp) / 1_000.0)
        } else {
            return "\(xp)"
        }
    }
    
    static func formatTimeAgo(_ dateString: String) -> String {
        guard let date = dateString.toDate() else { return dateString }
        
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else if interval < 604800 {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        } else {
            return DateFormatter.shortDate.string(from: date)
        }
    }
}

extension Int {
    var formattedDuration: String {
        Formatters.formatDuration(minutes: self)
    }
    
    var formattedXP: String {
        Formatters.formatXP(self)
    }
}
