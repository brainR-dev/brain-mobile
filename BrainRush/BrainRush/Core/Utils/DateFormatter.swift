//
//  DateFormatter.swift
//  BrainRush
//
//  Date formatting utilities
//

import Foundation

extension DateFormatter {
    static let relative: DateFormatter = {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}

extension String {
    func toRelativeDate() -> String {
        guard let date = self.toDate() else { return self }
        return DateFormatter.relative.string(from: date)
    }
}
