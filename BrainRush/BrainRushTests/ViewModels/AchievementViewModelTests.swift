//
//  AchievementViewModelTests.swift
//  BrainRushTests
//
//  Unit tests for AchievementViewModel
//

import XCTest
import Combine
@testable import BrainRush

@MainActor
final class AchievementViewModelTests: XCTestCase {
    var viewModel: AchievementViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = AchievementViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.achievements.isEmpty)
        XCTAssertTrue(viewModel.filteredAchievements.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.selectedCategory)
        XCTAssertNil(viewModel.selectedRarity)
    }
    
    func testCategoryFilter() {
        // Add mock achievements
        let achievement1 = MockDataFactory.makeAchievement(category: "getting_started")
        let achievement2 = MockDataFactory.makeAchievement(category: "learning")
        
        // Set achievements (would normally come from service)
        // For test, we simulate by setting directly
        viewModel.achievements = [achievement1, achievement2]
        
        // Filter by category
        viewModel.selectCategory("getting_started")
        
        // Wait for Combine pipeline
        let expectation = expectation(description: "Filter by category")
        
        viewModel.$filteredAchievements
            .dropFirst()
            .sink { achievements in
                XCTAssertEqual(achievements.count, 1)
                XCTAssertEqual(achievements.first?.category, "getting_started")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testRarityFilter() {
        let achievement1 = MockDataFactory.makeAchievement(rarity: "Rare")
        let achievement2 = MockDataFactory.makeAchievement(rarity: "Common")
        
        viewModel.achievements = [achievement1, achievement2]
        viewModel.selectRarity("Rare")
        
        let expectation = expectation(description: "Filter by rarity")
        
        viewModel.$filteredAchievements
            .dropFirst()
            .sink { achievements in
                XCTAssertEqual(achievements.count, 1)
                XCTAssertEqual(achievements.first?.rarity, "Rare")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testUnlockedCount() {
        let achievements = MockDataFactory.makeAchievements(count: 10, unlockedCount: 5)
        viewModel.achievements = achievements
        
        XCTAssertEqual(viewModel.unlockedCount, 5)
        XCTAssertEqual(viewModel.totalCount, 10)
    }
    
    func testCompletionPercentage() {
        let achievements = MockDataFactory.makeAchievements(count: 10, unlockedCount: 7)
        viewModel.achievements = achievements
        
        XCTAssertEqual(viewModel.completionPercentage, 0.7, accuracy: 0.01)
    }
}
