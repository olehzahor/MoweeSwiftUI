//
//  TypedMediasListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

struct TypedMediasListDataProvider: MediasListDataProvider {
    let mediaType: MediaType
    let movieFetcher: (Int) async throws -> PaginatedResponse<Movie>
    let tvShowFetcher: (Int) async throws -> PaginatedResponse<TVShow>

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        switch mediaType {
        case .movie:
            try await MoviesListDataProvider(
                fetcher: movieFetcher)
            .fetch(page: page)
        case .tvShow:
            try await TVShowsListDataProvider(
                fetcher: tvShowFetcher)
            .fetch(page: page)
        }
    }
}

extension TypedMediasListDataProvider {
    static func related(_ identifier: MediaIdentifier) -> Self {
        .init(
            mediaType: identifier.type) { page in
                return try await networkClient.request(
                    TMDB.MovieRecommendations(movieID: identifier.id, page: page)
                )
            } tvShowFetcher: { page in
                return try await networkClient.request(
                    TMDB.TVShowRecommendations(tvShowID: identifier.id, page: page)
                )
            }
    }
}

extension TypedMediasListDataProvider {
    static func customList(_ type: MediaType, path: String, query: String?) -> Self {
        return .init(mediaType: type) { page in
                return try await networkClient.request(
                    TMDB.CustomList<Movie>(page: page, path: path, query: query)
                )
            } tvShowFetcher: { page in
                return try await networkClient.request(
                    TMDB.CustomList<TVShow>(page: page, path: path, query: query)
                )
            }
    }
}
