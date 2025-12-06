//
//  DashboardService.swift
//  BrainRush
//
//  Dashboard service
//

import Foundation

@MainActor
class DashboardService: ObservableObject {
    static let shared = DashboardService()
    
    @Published var dashboardData: DashboardData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    func loadDashboard() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        guard let token = AuthService.shared.getAccessToken() else {
            errorMessage = "Not authenticated"
            return
        }
        
        do {
            let data: DashboardData = try await APIClient.shared.request(
                endpoint: "/mobile/dashboard",
                method: "GET",
                accessToken: token
            )
            self.dashboardData = data
        } catch {
            self.errorMessage = error.localizedDescription
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_dashboard"
            ])
        }
    }
}
