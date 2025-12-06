//
//  BrainRushApp.swift
//  BrainRush
//
//  Created by Oliver Pruskowski on 12/6/25.
//

import SwiftUI
import SwiftData

@main
struct BrainRushApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        // Initialize crash reporting first
        _ = CrashReporter.shared
        
        // Initialize analytics on app launch
        _ = AnalyticsService.shared
        
        // Initialize push notifications
        Task {
            await PushNotificationService.shared.requestAuthorization()
        }
        
        // Initialize network monitoring
        _ = NetworkMonitor.shared
        
        // Initialize app state tracking
        _ = AppStateTracker.shared
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AuthService.shared)
                .environmentObject(NavigationCoordinator.shared)
                .environment(\.appEnvironment, AppEnvironment.shared)
                .onOpenURL { url in
                    // Handle deep links
                    DeepLinkRouter.shared.handleURL(url)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
