//
//  FeedCachePolicy.swift
//  InstagramCloneFeed
//
//  Created by Pavel Palancica on 28.12.2023.
//

import Foundation

internal final class FeedCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    
    private init() {}
    
    private static var maxCacheAgeInDays: Int {
        return 3
    }
    
    internal static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day,
                                              value: maxCacheAgeInDays,
                                              to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}
