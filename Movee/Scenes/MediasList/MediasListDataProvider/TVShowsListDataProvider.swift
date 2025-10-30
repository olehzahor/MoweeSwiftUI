//
//  TVShowsListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

struct TVShowsListDataProvider: MediasListDataProvider {
    let networkClient: NetworkClient2
    let fetcher: (NetworkClient2, Int) async throws -> PaginatedResponse<TVShow>

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        try await fetcher(networkClient, page).map { Media(tvShow: $0) }
    }
}

extension TVShowsListDataProvider {
    static var popular = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.PopularTVShows(page: page))
    }

    static var topRated = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.TopRatedTVShows(page: page))
    }

    static var onTheAir = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.OnTheAirTVShows(page: page))
    }

    static var airingToday = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.AiringTodayTVShows(page: page))
    }
}
