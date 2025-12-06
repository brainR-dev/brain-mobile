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

    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    // Handle deep links
                    if let route = DeepLinkRouter.shared.handleUniversalLink(url) ?? DeepLinkRouter.shared.handleCustomURL(url) {
                        // Navigate to route (would need navigation state management)
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
