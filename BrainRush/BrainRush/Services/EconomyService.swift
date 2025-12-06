//
//  EconomyService.swift
//  BrainRush
//
//  Economy service
//

import Foundation

@MainActor
class EconomyService: ObservableObject {
    static let shared = EconomyService()
    
    @Published var tokenBalance: TokenBalance?
    @Published var transactions: [TokenTransaction] = []
    @Published var swagItems: [SwagItem] = []
    @Published var userAvatar: UserAvatar?
    @Published var isLoading = false
    
    private init() {}
    
    func loadTokenBalance() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let balance: TokenBalance = try await APIClient.shared.request(
                endpoint: "/mobile/economy",
                method: "GET",
                accessToken: token
            )
            self.tokenBalance = balance
        } catch {
            // Handle error
        }
    }
    
    func loadTransactions() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let transactions: [TokenTransaction] = try await APIClient.shared.request(
                endpoint: "/mobile/economy/transactions",
                method: "GET",
                accessToken: token
            )
            self.transactions = transactions
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_transactions"
            ])
        }
    }
    
    func loadSwagItems() async {
        guard let token = AuthService.shared.getAccessToken() else { return }
        
        do {
            let items: [SwagItem] = try await APIClient.shared.request(
                endpoint: "/mobile/swag",
                method: "GET",
                accessToken: token
            )
            self.swagItems = items
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "load_swag_items"
            ])
        }
    }
    
    func purchaseItem(itemId: String) async throws {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        // Get item details before purchase for tracking
        let item = swagItems.first(where: { $0.id == itemId })
        
        do {
            let _: EmptyResponse = try await APIClient.shared.request(
                endpoint: "/mobile/swag/\(itemId)/purchase",
                method: "POST",
                accessToken: token
            )
            
            // Track purchase
            if let item = item {
                AnalyticsService.shared.trackSwagPurchased(
                    itemId: itemId,
                    itemName: item.name,
                    price: item.price,
                    rarity: item.rarity
                )
                
                AnalyticsService.shared.trackTokenSpent(
                    amount: item.price,
                    itemId: itemId,
                    itemName: item.name
                )
            }
            
            await loadTokenBalance()
            await loadSwagItems()
        } catch {
            AnalyticsService.shared.trackError(error, context: [
                "action": "purchase_item",
                "item_id": itemId
            ])
            throw error
        }
    }
    
    func updateAvatar(items: [AvatarItem]) async throws {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let _: EmptyResponse = try await APIClient.shared.request(
            endpoint: "/mobile/avatar/update",
            method: "POST",
            accessToken: token,
            body: ["items": items.map { ["item_id": $0.itemId, "category": $0.category, "is_equipped": $0.isEquipped] }]
        )
    }
}
