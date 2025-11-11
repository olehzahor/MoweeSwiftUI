//
//  TypedMediasListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation



struct TypedMediasListDataProvider: MediasListDataProvider {
    let networkClient: NetworkClient2
    
    let mediaType: MediaType
    let movieFetcher: (NetworkClient2, Int) async throws -> PaginatedResponse<Movie>
    let tvShowFetcher: (NetworkClient2, Int) async throws -> PaginatedResponse<TVShow>

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        switch mediaType {
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
            mediaType: identifier.type) { networkClient, page in
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

extension TypedMediasListDataProvider {
    static func customList(_ type: MediaType, path: String, query: String?) -> Self {
        return .init(
            networkClient: Dependencies.networkClient,
            mediaType: type) { network, page in
                try await network.request(
                    TMDB.CustomList<Movie>(page: page, path: path, query: query)
                )
            } tvShowFetcher: { network, page in
                try await network.request(
                    TMDB.CustomList<TVShow>(page: page, path: path, query: query)
                )
            }
    }
}
