//
//  TypedMediasListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

struct TypedMediasListDataProvider: MediasListDataProvider {
    let networkClient: NetworkClient2
    
    let mediaIdentifier: MediaIdentifier
    let movieFetcher: (NetworkClient2, Int) async throws -> PaginatedResponse<Movie>
    let tvShowFetcher: (NetworkClient2, Int) async throws -> PaginatedResponse<TVShow>

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        switch mediaIdentifier.type {
        case .movie:
            let response = try await movieFetcher(networkClient, page)
            return response.map { Media(movie: $0) }
        case .tvShow:
            let response = try await tvShowFetcher(networkClient, page)
            return response.map { Media(tvShow: $0) }
        }
    }
}

extension TypedMediasListDataProvider {
    static func related(_ identifier: MediaIdentifier) -> Self {
        .init(
            networkClient: Dependencies.networkClient,
            mediaIdentifier: identifier) { networkClient, page in
                try await networkClient.request(
                    TMDB.MovieRecommendations(movieID: identifier.id, page: page)
                )
            } tvShowFetcher: { networkClient, page in
                try await networkClient.request(
                    TMDB.TVShowRecommendations(tvShowID: identifier.id, page: page)
                )
            }
    }
}
