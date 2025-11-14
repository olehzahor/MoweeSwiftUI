//
//  TVShowsListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

struct TVShowsListDataProvider: MediasListDataProvider {
    let fetcher: (Int) async throws -> PaginatedResponse<TVShow>

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        try await fetcher(page).map { Media(tvShow: $0) }
    }
}

extension TVShowsListDataProvider {
    static var popular = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.PopularTVShows(page: page))
    }

    static var topRated = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.TopRatedTVShows(page: page))
    }

    static var onTheAir = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.OnTheAirTVShows(page: page))
    }

    static var airingToday = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.AiringTodayTVShows(page: page))
    }
}
