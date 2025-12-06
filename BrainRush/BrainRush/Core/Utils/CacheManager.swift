//
//  CacheManager.swift
//  BrainRush
//
//  Simple cache manager for images and data
//

import Foundation
import UIKit

actor CacheManager {
    static let shared = CacheManager()
    
    private var imageCache: [String: UIImage] = [:]
    private var dataCache: [String: Data] = [:]
    private let maxCacheSize = 50 * 1024 * 1024 // 50 MB
    private var currentCacheSize: Int = 0
    
    private init() {}
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        let data = image.pngData()
        let size = data?.count ?? 0
        
        if currentCacheSize + size > maxCacheSize {
            clearOldestEntries(needed: size)
        }
        
        imageCache[key] = image
        if let data = data {
            dataCache[key] = data
            currentCacheSize += size
        }
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return imageCache[key]
    }
    
    func cacheData(_ data: Data, forKey key: String) {
        if currentCacheSize + data.count > maxCacheSize {
            clearOldestEntries(needed: data.count)
        }
        
        dataCache[key] = data
        currentCacheSize += data.count
    }
    
    func getData(forKey key: String) -> Data? {
        return dataCache[key]
    }
    
    func clearCache() {
        imageCache.removeAll()
        dataCache.removeAll()
        currentCacheSize = 0
    }
    
    private func clearOldestEntries(needed: Int) {
        // Simple implementation: clear all and start fresh
        // In production, implement LRU cache
        imageCache.removeAll()
        dataCache.removeAll()
        currentCacheSize = 0
    }
}
