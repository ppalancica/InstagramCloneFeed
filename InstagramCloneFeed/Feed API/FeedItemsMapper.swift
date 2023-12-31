//
//  FeedItemsMapper.swift
//  InstagramCloneFeed
//
//  Created by Pavel Palancica on 14.12.2023.
//

import Foundation

internal final class FeedItemsMapper {
    private struct Root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
              let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items
    }
}


//private struct Item: Decodable {
//    let id: UUID
//    let description: String?
//    let location: String?
//    let image: URL
//
//    var item: FeedItem {
//        return FeedItem(id: id,
//                        description: description,
//                        location: location,
//                        imageURL: image)
//    }
//}
//
//internal final class FeedItemsMapper {
//    private struct Root: Decodable {
//        let items: [Item]
//
//        var feed: [FeedItem] {
//            return items.map { $0.item }
//        }
//    }
//
//    private static var OK_200: Int { return 200 }
//
//    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
//        guard response.statusCode == OK_200,
//              let root = try? JSONDecoder().decode(Root.self, from: data) else {
//            return .failure(RemoteFeedLoader.Error.invalidData)
//        }
//        return .success(root.feed)
//    }
//}
