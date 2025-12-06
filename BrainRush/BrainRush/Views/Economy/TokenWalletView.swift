//
//  TokenWalletView.swift
//  BrainRush
//
//  Token wallet view
//

import SwiftUI

struct TokenWalletView: View {
    @StateObject private var economyService = EconomyService.shared
    @State private var transactions: [TokenTransaction] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Balance Card
                    VStack(spacing: 16) {
                        Text("Brain-R Tokens")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if let balance = economyService.tokenBalance {
                            Text("\(balance.balance)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.blue)
                            
                            HStack(spacing: 32) {
                                VStack {
                                    Text("Earned")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("\(balance.totalEarned)")
                                        .font(.headline)
                                }
                                
                                VStack {
                                    Text("Spent")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("\(balance.totalSpent)")
                                        .font(.headline)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .padding()
                    
                    // Transaction History
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Transaction History")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                }
            }
            .navigationTitle("Wallet")
            .task {
                await economyService.loadTokenBalance()
                await loadTransactions()
            }
        }
    }
    
    private func loadTransactions() async {
        await economyService.loadTransactions()
        transactions = economyService.transactions
    }
}

struct TransactionRow: View {
    let transaction: TokenTransaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.type == "earn" ? "plus.circle.fill" : "minus.circle.fill")
                .foregroundColor(transaction.type == "earn" ? .green : .red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.reason)
                    .font(.subheadline)
                Text(formatDate(transaction.createdAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(transaction.type == "earn" ? "+\(transaction.amount)" : "-\(transaction.amount)")
                .font(.headline)
                .foregroundColor(transaction.type == "earn" ? .green : .red)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    private func formatDate(_ dateString: String) -> String {
        // Format date
        return dateString
    }
}


#Preview {
    TokenWalletView()
}
