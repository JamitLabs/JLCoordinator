//
//  WeakCacheTests.swift
//  CoordinatorBaseTests
//
//  Created by Jens Krug on 12.06.20.
//  Copyright © 2020 Jamit Labs. All rights reserved.
//

import CoordinatorBase
import XCTest

class WeakCacheTests: XCTestCase {
    func testAddingElement() throws {
        let cache: WeakCache<CacheableElement>  = .init()

        let element = CacheableElement()
        cache.append(element)

        XCTAssertTrue(cache.contains(element))

        let cachedElement = cache.all.first { $0.identifier == element.identifier }
        XCTAssertNotNil(cachedElement)
    }

    func testRemovingElement() throws {
        let cache: WeakCache<CacheableElement>  = .init()

        // Add element
        let element = CacheableElement()
        cache.append(element)
        XCTAssertTrue(cache.contains(element))

        cache.remove(element)
        XCTAssertFalse(cache.contains(element))
    }

    func testRemovingAllElements() throws {
        let cache: WeakCache<CacheableElement>  = .init()

        let generatedElements: [CacheableElement] = (0 ..< 10).map { _ in CacheableElement() }
        generatedElements.forEach { cache.append($0) }
        XCTAssertEqual(cache.all.count, 10)
        cache.removeAll()

        XCTAssertEqual(cache.all.count, 0)
    }

    func testElementShouldNotBeReferencedStrong() throws {
        let cache: WeakCache<CacheableElement>  = .init()

        cache.append(CacheableElement())
        XCTAssertTrue(cache.all.isEmpty)
    }
}
