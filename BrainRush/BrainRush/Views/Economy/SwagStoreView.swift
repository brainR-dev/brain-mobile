//
//  SwagStoreView.swift
//  BrainRush
//
//  Swag store view
//

import SwiftUI

struct SwagStoreView: View {
    @StateObject private var economyService = EconomyService.shared
    @State private var selectedCategory: String?
    
    private var swagItems: [SwagItem] {
        economyService.swagItems
    }
    
    var filteredItems: [SwagItem] {
        if let category = selectedCategory {
            return swagItems.filter { $0.category == category }
        }
        return swagItems
    }
    
    var categories: [String] {
        Array(Set(swagItems.map { $0.category })).sorted()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterChip(title: "All", isSelected: selectedCategory == nil) {
                            selectedCategory = nil
                        }
                        
                        ForEach(categories, id: \.self) { category in
                            FilterChip(title: category.capitalized, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Items Grid
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                        ForEach(filteredItems) { item in
                            SwagItemCard(item: item)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Swag Store")
            .task {
                await economyService.loadSwagItems()
            }
        }
    }
}

struct SwagItemCard: View {
    let item: SwagItem
    @State private var showPurchaseConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Item Image
            RoundedRectangle(cornerRadius: 8)
                .fill(rarityColor.opacity(0.2))
                .frame(height: 120)
                .overlay(
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 40))
                        .foregroundColor(rarityColor)
                )
                .overlay(
                    RarityBadge(rarity: item.rarity)
                        .padding(8),
                    alignment: .topTrailing
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                if let description = item.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text("\(item.price)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                
                if item.isOwned == true {
                    Text("Owned")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                } else {
                    Button("Buy") {
                        showPurchaseConfirmation = true
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("Purchase \(item.name)?", isPresented: $showPurchaseConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Purchase") {
                Task {
                    do {
                        try await EconomyService.shared.purchaseItem(itemId: item.id)
                    } catch {
                        // Handle error
                    }
                }
            }
        } message: {
            Text("This will cost \(item.price) tokens.")
        }
    }
    
    private var rarityColor: Color {
        switch item.rarity {
        case "Common": return .gray
        case "Uncommon": return .green
        case "Rare": return .blue
        case "Epic": return .purple
        case "Legendary": return .orange
        case "Mythic": return .red
        default: return .gray
        }
    }
}

struct RarityBadge: View {
    let rarity: String
    
    var body: some View {
        Text(rarity)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(rarityColor.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(4)
    }
    
    private var rarityColor: Color {
        switch rarity {
        case "Common": return .gray
        case "Uncommon": return .green
        case "Rare": return .blue
        case "Epic": return .purple
        case "Legendary": return .orange
        case "Mythic": return .red
        default: return .gray
        }
    }
}

#Preview {
    SwagStoreView()
}
