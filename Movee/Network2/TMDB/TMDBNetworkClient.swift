//
//  TMDBNetworkClient.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

//final class TMDBNetworkClient {
//    static let shared = TMDBNetworkClient()
//
//    private let client: NetworkClient2
//
//    private init() {
//        self.client = NetworkClient2(
//            interceptors: [TMDBInterceptor()],
//            decoder: TMDBJSONDecoder()
//        )
//    }
//
//    // MARK: - Request Methods
//
//    @discardableResult
//    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
//        try await client.request(endpoint)
//    }
//
//    func request(_ endpoint: Endpoint) async throws -> Data {
//        try await client.request(endpoint)
//    }
//
//    func request(_ endpoint: Endpoint) async throws {
//        //try await client.request(endpoint)
//    }
//}
