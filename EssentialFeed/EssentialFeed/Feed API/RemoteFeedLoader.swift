//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Ahmed Atef Ali Ahmed on 14.05.21.
//

public typealias LoaderResult = Result<[FeedItem], RemoteFeedLoader.Error>

public final class RemoteFeedLoader {

    /// Remote Feed Loader domain Errors.
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private let url: URL
    private let client: HTTPClient

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (LoaderResult) -> Void) {
        client.request(from: url) { result in
            switch result {
            case .success((let data, let response)):
                do {
                    let result = try FeedItemMapper.map(data, response)
                    completion(.success(result))
                } catch RemoteFeedLoader.Error.connectivity {
                    completion(.failure(.connectivity))
                } catch RemoteFeedLoader.Error.invalidData {
                    completion(.failure(.invalidData))
                } catch {
                    preconditionFailure("Unexpected error!")
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
