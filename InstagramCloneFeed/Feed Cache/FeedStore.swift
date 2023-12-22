//
//  FeedStore.swift
//  InstagramCloneFeed
//
//  Created by Pavel Palancica on 22.12.2023.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem],
                timestamp: Date,
                completion: @escaping InsertionCompletion)
}
