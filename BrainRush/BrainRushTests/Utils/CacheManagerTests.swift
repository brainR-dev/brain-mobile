//
//  CacheManagerTests.swift
//  BrainRushTests
//
//  Unit tests for CacheManager
//

import XCTest
@testable import BrainRush

final class CacheManagerTests: XCTestCase {
    var cacheManager: CacheManager!
    
    override func setUp() {
        super.setUp()
        cacheManager = CacheManager.shared
    }
    
    func testImageCaching() async {
        let testImage = UIImage(systemName: "star.fill")!
        let key = "test_image_1"
        
        await cacheManager.cacheImage(testImage, forKey: key)
        
        let cachedImage = await cacheManager.getImage(forKey: key)
        XCTAssertNotNil(cachedImage)
    }
    
    func testDataCaching() async {
        let testData = "Test data".data(using: .utf8)!
        let key = "test_data_1"
        
        await cacheManager.cacheData(testData, forKey: key)
        
        let cachedData = await cacheManager.getData(forKey: key)
        XCTAssertNotNil(cachedData)
        XCTAssertEqual(cachedData, testData)
    }
    
    func testCacheClear() async {
        let testData = "Test data".data(using: .utf8)!
        await cacheManager.cacheData(testData, forKey: "test_key")
        
        await cacheManager.clearCache()
        
        let cachedData = await cacheManager.getData(forKey: "test_key")
        XCTAssertNil(cachedData)
    }
}

#if canImport(UIKit)
import UIKit
#endif
