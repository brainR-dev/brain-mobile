//
//  ErrorTracker.swift
//  BrainRush
//
//  Global error tracking utility
//

import Foundation

struct ErrorTracker {
    static func track(_ error: Error, context: [String: Any]? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        var errorContext: [String: Any] = [
            "file": (file as NSString).lastPathComponent,
            "function": function,
            "line": line
        ]
        
        if let context = context {
            errorContext.merge(context) { (_, new) in new }
        }
        
        // Track to PostHog
        AnalyticsService.shared.trackError(error, context: errorContext)
        
        // Log locally
        Logger.shared.error("Error: \(error.localizedDescription)", file: file, function: function, line: line)
    }
}

// Global error handler
extension View {
    func trackErrors() -> some View {
        self.onAppear {
            // Set up global error handlers if needed
        }
    }
}
