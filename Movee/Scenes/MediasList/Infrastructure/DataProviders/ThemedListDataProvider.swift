//
//  ThemedListDataProvider.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Factory

struct ThemedListDataProvider: MediasListDataProvider {
    let networkClient: NetworkClient2
    
    let listID: Int

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        try await networkClient.request(TMDB.List(page: page, listID: listID)).paginatedResponse
    }
    
    init(networkClient: NetworkClient2 = Container.shared.networkClient(), listID: Int) {
        self.networkClient = networkClient
        self.listID = listID
    }
}
