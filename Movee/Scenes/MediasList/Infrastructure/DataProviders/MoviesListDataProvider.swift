//
//  MoviesListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

struct MoviesListDataProvider: MediasListDataProvider {
    let fetcher: (Int) async throws -> PaginatedResponse<Movie>
    
    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        try await fetcher(page).map { Media(movie: $0) }
    }
}

extension MoviesListDataProvider {
    static var popular = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.PopularMovies(page: page))
    }

    static var nowPlaying = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.NowPlayingMovies(page: page))
    }

    static var upcoming = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.UpcomingMovies(page: page))
    }

    static var topRated = Self { page in
        let networkClient = Dependencies.networkClient
        return try await networkClient.request(TMDB.TopRatedMovies(page: page))
    }
}
