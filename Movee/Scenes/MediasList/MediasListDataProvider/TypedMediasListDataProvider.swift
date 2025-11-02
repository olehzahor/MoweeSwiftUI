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
            try await MoviesListDataProvider(
                networkClient: networkClient,
                fetcher: movieFetcher)
            .fetch(page: page)
        case .tvShow:
            try await TVShowsListDataProvider(
                networkClient: networkClient,
                fetcher: tvShowFetcher)
            .fetch(page: page)
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
