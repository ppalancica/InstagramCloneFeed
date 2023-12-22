//
//  RemoteFeedItem.swift
//  InstagramCloneFeed
//
//  Created by Pavel Palancica on 22.12.2023.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
