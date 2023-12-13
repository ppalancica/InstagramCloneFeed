//
//  FeedItem.swift
//  InstagramCloneFeed
//
//  Created by Pavel Palancica on 03.12.2023.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
