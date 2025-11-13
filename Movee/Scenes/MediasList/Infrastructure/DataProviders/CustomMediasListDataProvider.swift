//
//  CustomMediasListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

struct CustomMediasListDataProvider: MediasListDataProvider {
    let networkClient: NetworkClient2
    let fetcher: (NetworkClient2, Int) async throws -> PaginatedResponse<Media>
    
    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        try await fetcher(networkClient, page)
    }
    
    init(networkClient: NetworkClient2 = Dependencies.networkClient, fetcher: @escaping (NetworkClient2, Int) async throws -> PaginatedResponse<Media>) {
        self.networkClient = networkClient
        self.fetcher = fetcher
    }
}
