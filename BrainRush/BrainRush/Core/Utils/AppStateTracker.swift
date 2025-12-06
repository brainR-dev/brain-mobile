//
//  AppStateTracker.swift
//  BrainRush
//
//  Track app lifecycle events for analytics
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#endif

class AppStateTracker: ObservableObject {
    static let shared = AppStateTracker()
    
    @Published var isActive = true
    private var backgroundTime: Date?
    
    private init() {
        setupNotifications()
    }
    
    private func setupNotifications() {
        #if os(iOS)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        #endif
    }
    
    @objc private func appDidBecomeActive() {
        isActive = true
        
        // Track app activation
        AnalyticsService.shared.track("app_became_active")
        
        // Track time in background if available
        if let backgroundTime = backgroundTime {
            let timeInBackground = Date().timeIntervalSince(backgroundTime)
            AnalyticsService.shared.track("app_foregrounded", properties: [
                "time_in_background_seconds": Int(timeInBackground)
            ])
            self.backgroundTime = nil
        }
    }
    
    @objc private func appWillResignActive() {
        isActive = false
        AnalyticsService.shared.track("app_will_resign_active")
    }
    
    @objc private func appDidEnterBackground() {
        backgroundTime = Date()
        AnalyticsService.shared.track("app_entered_background")
    }
    
    @objc private func appWillEnterForeground() {
        AnalyticsService.shared.track("app_will_enter_foreground")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
