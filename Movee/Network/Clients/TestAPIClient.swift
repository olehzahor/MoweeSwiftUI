//
//  TestAPIClient.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation
import Combine

// A simple model representing a post from JSONPlaceholder.
struct Post: Decodable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

final class TestAPIClient {
    static let shared = TestAPIClient()
    
    /// Fetches posts from JSONPlaceholder.
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        // URL for fetching posts.
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            let badURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
            let requestDetails = NetworkError.RequestDetails(url: badURL, method: .get, parameters: nil)
            return Fail(error: NetworkError(request: requestDetails, response: nil, underlyingError: URLError(.badURL)))
                .eraseToAnyPublisher()
        }
        
        // Use our NetworkManager to perform the request.
        return NetworkManager.shared.request(url: url, method: .get, parameters: nil)
    }
}
