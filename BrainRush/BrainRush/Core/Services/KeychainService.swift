//
//  KeychainService.swift
//  BrainRush
//
//  Keychain service for secure storage
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()
    
    private let service = AppConfig.bundleID
    
    private init() {}
    
    // MARK: - Access Token
    
    func saveAccessToken(_ token: String) {
        save(key: "access_token", value: token)
    }
    
    func getAccessToken() -> String? {
        return get(key: "access_token")
    }
    
    // MARK: - Refresh Token
    
    func saveRefreshToken(_ token: String) {
        save(key: "refresh_token", value: token)
    }
    
    func getRefreshToken() -> String? {
        return get(key: "refresh_token")
    }
    
    // MARK: - User ID
    
    func saveUserId(_ userId: String) {
        save(key: "user_id", value: userId)
    }
    
    func getUserId() -> String? {
        return get(key: "user_id")
    }
    
    // MARK: - Email
    
    func saveEmail(_ email: String) {
        save(key: "user_email", value: email)
    }
    
    func getEmail() -> String? {
        return get(key: "user_email")
    }
    
    // MARK: - Generic Methods
    
    private func save(key: String, value: String) {
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item if it exists
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func get(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    func clearAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
