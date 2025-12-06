//
//  AnalyticsMiddleware.swift
//  BrainRush
//
//  Middleware for automatic analytics tracking
//

import Foundation
import SwiftUI

// Track view appearances automatically
extension View {
    func trackAnalytics(_ screenName: String, properties: [String: Any]? = nil) -> some View {
        self.onAppear {
            AnalyticsService.shared.trackScreen(screenName, properties: properties)
        }
    }
    
    func trackButtonTap(_ eventName: String, properties: [String: Any]? = nil) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                AnalyticsService.shared.track(eventName, properties: properties)
            }
        )
    }
}
