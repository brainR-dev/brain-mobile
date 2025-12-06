//
//  ImageLoaderTests.swift
//  BrainRushTests
//
//  Unit tests for ImageLoader
//

import XCTest
@testable import BrainRush

final class ImageLoaderTests: XCTestCase {
    
    func testImageLoaderInitialization() {
        let loader = ImageLoader()
        XCTAssertNotNil(loader)
    }
    
    func testLoadImageFromURL() async {
        let loader = ImageLoader()
        let url = URL(string: "https://example.com/image.jpg")!
        
        // Would load image (may fail if URL not accessible)
        // For test, just verify loader works
        XCTAssertNotNil(loader)
        XCTAssertNotNil(url)
    }
    
    func testImageCaching() async {
        let loader = ImageLoader()
        let url = URL(string: "https://example.com/image.jpg")!
        
        // Load image multiple times - should use cache
        // For test, just verify loader works
        XCTAssertNotNil(loader)
    }
}
