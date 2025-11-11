//
//  ThemedListDataProvider.swift
//  Movee
//
//  Created by user on 11/10/25.
//

struct ThemedListDataProvider: MediasListDataProvider {
    let networkClient: NetworkClient2
    
    let listID: Int

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        try await networkClient.request(TMDB.List(page: page, listID: listID)).paginatedResponse
    }
    
    init(networkClient: NetworkClient2 = Dependencies.networkClient, listID: Int) {
        self.networkClient = networkClient
        self.listID = listID
    }
}
