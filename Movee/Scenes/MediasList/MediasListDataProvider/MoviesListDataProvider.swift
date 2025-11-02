//
//  MoviesListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

struct MoviesListDataProvider: MediasListDataProvider {
    let networkClient: NetworkClient2
    let fetcher: (NetworkClient2, Int) async throws -> PaginatedResponse<Movie>
    
    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        try await fetcher(networkClient, page).map { Media(movie: $0) }
    }
}

extension MoviesListDataProvider {
    static var popular = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.PopularMovies(page: page))
    }

    static var nowPlaying = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.NowPlayingMovies(page: page))
    }

    static var upcoming = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.UpcomingMovies(page: page))
    }

    static var topRated = Self(networkClient: Dependencies.networkClient) { networkClient, page in
        try await networkClient.request(TMDB.TopRatedMovies(page: page))
    }
}
