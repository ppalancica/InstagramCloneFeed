//
//  XCTestCase+MemoryLeakTracking.swift
//  InstagramCloneFeedTests
//
//  Created by Pavel Palancica on 17.12.2023.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject,
                             file: StaticString = #file, // #filePath
                             line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            // Runs after each test
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
