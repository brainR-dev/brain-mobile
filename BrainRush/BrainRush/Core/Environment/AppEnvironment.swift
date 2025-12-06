//
//  AppEnvironment.swift
//  BrainRush
//
//  App-wide environment and dependencies
//

import SwiftUI

class AppEnvironment: ObservableObject {
    static let shared = AppEnvironment()
    
    let authService = AuthService.shared
    let dashboardService = DashboardService.shared
    let courseService = CourseService.shared
    let programService = ProgramService.shared
    let gamificationService = GamificationService.shared
    let economyService = EconomyService.shared
    let socialService = SocialService.shared
    let navigationCoordinator = NavigationCoordinator.shared
    
    private init() {}
}

struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue = AppEnvironment.shared
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
}
