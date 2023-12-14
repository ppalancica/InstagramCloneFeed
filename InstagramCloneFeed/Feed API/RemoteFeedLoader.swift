//
//  RemoteFeedLoader.swift
//  InstagramCloneFeed
//
//  Created by Pavel Palanica on 08.12.2023.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
                case let .success(data, response):
                    completion(FeedItemsMapper.map(data, from: response))
//                    do {
//                        let items = try FeedItemsMapper.map(data, response)
//                        completion(.success(items))
//                    } catch {
//                        completion(.failure(.invalidData))
//                    }
                case .failure:
                    completion(.failure(.connectivity))
            }
        }
    }
}
