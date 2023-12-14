//
//  FeedLoader.swift
//  InstagramCloneFeed
//
//  Created by Pavel Palancica on 03.12.2023.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
