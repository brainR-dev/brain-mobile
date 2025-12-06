//
//  DashboardViewModel.swift
//  BrainRush
//
//  Dashboard view model for MVVM pattern
//

import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var dashboardData: DashboardData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let dashboardService = DashboardService.shared
    private let gamificationService = GamificationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        // Observe dashboard service changes
        dashboardService.$dashboardData
            .assign(to: &$dashboardData)
        
        dashboardService.$isLoading
            .assign(to: &$isLoading)
        
        dashboardService.$errorMessage
            .assign(to: &$errorMessage)
    }
    
    func loadDashboard() async {
        await dashboardService.loadDashboard()
    }
    
    func refresh() async {
        await dashboardService.loadDashboard()
        await gamificationService.loadUserXP()
    }
}
