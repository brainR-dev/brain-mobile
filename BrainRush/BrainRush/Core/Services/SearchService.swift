//
//  SearchService.swift
//  BrainRush
//
//  Search service
//

import Foundation

struct SearchResult: Codable {
    let courses: [Course]
    let programs: [Program]
    let forums: [ForumThread]?
    let users: [UserBasic]?
    
    enum CodingKeys: String, CodingKey {
        case courses, programs, forums, users
    }
}

@MainActor
class SearchService: ObservableObject {
    static let shared = SearchService()
    
    @Published var searchHistory: [String] = []
    @Published var recentSearches: [String] = []
    
    private init() {
        loadSearchHistory()
    }
    
    func search(query: String) async throws -> SearchResult {
        guard let token = AuthService.shared.getAccessToken() else {
            throw APIError.unauthorized
        }
        
        let results: SearchResult = try await APIClient.shared.request(
            endpoint: "/mobile/search?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")",
            method: "GET",
            accessToken: token
        )
        
        addToHistory(query)
        return results
    }
    
    private func addToHistory(_ query: String) {
        if !searchHistory.contains(query) {
            searchHistory.insert(query, at: 0)
            if searchHistory.count > 10 {
                searchHistory.removeLast()
            }
            saveSearchHistory()
        }
    }
    
    private func loadSearchHistory() {
        if let data = UserDefaults.standard.data(forKey: "search_history"),
           let history = try? JSONDecoder().decode([String].self, from: data) {
            self.searchHistory = history
            self.recentSearches = Array(history.prefix(5))
        }
    }
    
    private func saveSearchHistory() {
        if let data = try? JSONEncoder().encode(searchHistory) {
            UserDefaults.standard.set(data, forKey: "search_history")
        }
    }
}
