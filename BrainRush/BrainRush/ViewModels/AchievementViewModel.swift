//
//  AchievementViewModel.swift
//  BrainRush
//
//  Achievement view model for MVVM pattern
//

import Foundation
import Combine

@MainActor
class AchievementViewModel: ObservableObject {
    @Published var achievements: [Achievement] = []
    @Published var filteredAchievements: [Achievement] = []
    @Published var isLoading = false
    @Published var selectedCategory: String?
    @Published var selectedRarity: String?
    
    private let gamificationService = GamificationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        gamificationService.$achievements
            .assign(to: &$achievements)
        
        gamificationService.$isLoading
            .assign(to: &$isLoading)
        
        // Filter achievements when filters change
        Publishers.CombineLatest3($achievements, $selectedCategory, $selectedRarity)
            .map { achievements, category, rarity in
                var filtered = achievements
                
                if let category = category {
                    filtered = filtered.filter { $0.category == category }
                }
                
                if let rarity = rarity {
                    filtered = filtered.filter { $0.rarity == rarity }
                }
                
                return filtered
            }
            .assign(to: &$filteredAchievements)
    }
    
    func loadAchievements() async {
        await gamificationService.loadAchievements()
    }
    
    func selectCategory(_ category: String?) {
        selectedCategory = category
    }
    
    func selectRarity(_ rarity: String?) {
        selectedRarity = rarity
    }
    
    var unlockedCount: Int {
        achievements.filter { $0.isUnlocked == true }.count
    }
    
    var totalCount: Int {
        achievements.count
    }
    
    var completionPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(unlockedCount) / Double(totalCount)
    }
}
