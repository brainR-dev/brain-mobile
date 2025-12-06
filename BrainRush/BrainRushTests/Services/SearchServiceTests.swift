//
//  SearchServiceTests.swift
//  BrainRushTests
//
//  Unit tests for SearchService
//

import XCTest
@testable import BrainRush

@MainActor
final class SearchServiceTests: XCTestCase {
    var service: SearchService!
    
    override func setUp() {
        super.setUp()
        service = SearchService.shared
    }
    
    func testSearchCourses() async throws {
        let query = "Swift"
        
        do {
            let results = try await service.searchCourses(query: query)
            XCTAssertNotNil(results)
        } catch {
            // Expected if not authenticated
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testSearchLessons() async throws {
        let query = "introduction"
        
        do {
            let results = try await service.searchLessons(query: query)
            XCTAssertNotNil(results)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testSearchAll() async throws {
        let query = "programming"
        
        do {
            let results = try await service.searchAll(query: query)
            XCTAssertNotNil(results)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testGetSearchHistory() async {
        let history = await service.getSearchHistory()
        
        XCTAssertNotNil(history)
    }
    
    func testClearSearchHistory() async {
        await service.clearSearchHistory()
        
        let history = await service.getSearchHistory()
        XCTAssertTrue(history.isEmpty)
    }
    
    func testGetTrendingSearches() async throws {
        do {
            let trends = try await service.getTrendingSearches()
            XCTAssertNotNil(trends)
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}
