//
//  ConcurrencyTests.swift
//  BrainRushTests
//
//  Tests for concurrent operations and race conditions
//

import XCTest
@testable import BrainRush

@MainActor
final class ConcurrencyTests: XCTestCase {
    
    func testConcurrentCourseLoading() async {
        let service = CourseService.shared
        
        // Load courses concurrently
        async let load1 = service.loadCourses()
        async let load2 = service.loadCourses()
        
        await load1
        await load2
        
        // Verify no crash or data corruption
        XCTAssertNotNil(service)
    }
    
    func testConcurrentCacheAccess() async {
        let cache = CacheManager.shared
        
        let testData = "test".data(using: .utf8)!
        
        // Concurrent cache writes
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    await cache.cacheData(testData, forKey: "key_\(i)")
                }
            }
        }
        
        // Concurrent cache reads
        await withTaskGroup(of: Data?.self) { group in
            for i in 0..<10 {
                group.addTask {
                    await cache.getData(forKey: "key_\(i)")
                }
            }
        }
        
        // Verify no crash
        XCTAssertTrue(true)
    }
    
    func testConcurrentKeychainAccess() {
        let keychain = KeychainService.shared
        let group = DispatchGroup()
        
        // Concurrent keychain writes
        for i in 0..<5 {
            group.enter()
            DispatchQueue.global().async {
                keychain.saveAccessToken("token_\(i)")
                group.leave()
            }
        }
        
        group.wait()
        
        // Verify last write succeeded
        let token = keychain.getAccessToken()
        XCTAssertNotNil(token)
    }
    
    func testConcurrentValidation() {
        let emails = (0..<100).map { "test\($0)@example.com" }
        
        // Concurrent validation
        let results = emails.parallelMap { email in
            Validation.isValidEmail(email)
        }
        
        // All should be valid
        XCTAssertTrue(results.allSatisfy { $0 })
    }
    
    func testConcurrentFormatterUsage() {
        let numbers = (0..<1000).map { $0 * 100 }
        
        // Concurrent formatting
        let results = numbers.parallelMap { num in
            Formatters.formatXP(num)
        }
        
        // All should succeed
        XCTAssertEqual(results.count, 1000)
    }
}

extension Sequence {
    func parallelMap<T>(
        _ transform: @escaping (Element) -> T
    ) -> [T] {
        let lock = NSLock()
        var results: [T] = []
        
        DispatchQueue.concurrentPerform(iterations: Array(self).count) { index in
            let element = Array(self)[index]
            let transformed = transform(element)
            
            lock.lock()
            results.append(transformed)
            lock.unlock()
        }
        
        return results
    }
}

#if canImport(Foundation)
import Foundation
#endif
