//
//  SharedTestHelpers.swift
//  InstagramCloneFeedTests
//
//  Created by Pavel Palancica on 25.12.2023.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "https://any-url.com")!
}
