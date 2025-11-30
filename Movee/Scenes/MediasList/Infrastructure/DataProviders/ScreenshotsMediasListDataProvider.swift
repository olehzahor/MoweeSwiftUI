//
//  ScreenshotsMediasListDataProvider.swift
//  Movee
//
//  Created by user on 11/30/25.
//

import Foundation

struct ScreenshotsMediasListDataProvider: MediasListDataProvider {
    private let offset: Int

    /// Copyright-free movies with valid TMDB IDs for App Store screenshots
    /// All movies are either public domain or Creative Commons licensed
    private static let copyrightFreeMovieIDs: [Int] = [
        10378,  // Big Buck Bunny (2008) - Creative Commons
        19,     // Metropolis (1927) - Public Domain
        10331,  // Night of the Living Dead (1968) - Public Domain
        653,    // Nosferatu (1922) - Public Domain
        234,    // The Cabinet of Dr. Caligari (1920) - Public Domain
        775,    // A Trip to the Moon (1902) - Public Domain
        643,    // Battleship Potemkin (1925) - Public Domain
        10513,  // Plan 9 from Outer Space (1959) - Public Domain
        961,    // The General (1926) - Public Domain
        3085,   // His Girl Friday (1940) - Public Domain
        992,    // Sherlock Jr. (1924) - Public Domain
        964,    // The Phantom of the Opera (1925) - Public Domain
        24452,  // The Little Shop of Horrors (1960) - Public Domain
        31655,  // The Terror (1963) - Public Domain
        4808,   // Charade (1963) - Public Domain
    ]

    init(offset: Int = 0) {
        self.offset = offset
    }

    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        let startIndex = offset
        let endIndex = min(startIndex + Self.copyrightFreeMovieIDs.count, Self.copyrightFreeMovieIDs.count)

        guard startIndex < Self.copyrightFreeMovieIDs.count else {
            return PaginatedResponse(
                page: page,
                results: [],
                total_pages: 1,
                total_results: 0
            )
        }

        let movieIDsSlice = Array(Self.copyrightFreeMovieIDs[startIndex..<endIndex])

        // Fetch movies by IDs from TMDB
        let movies = try await fetchMoviesByIDs(movieIDsSlice)

        return PaginatedResponse(
            page: page,
            results: movies,
            total_pages: 1,
            total_results: movies.count
        )
    }

    private func fetchMoviesByIDs(_ ids: [Int]) async throws -> [Media] {
        try await withThrowingTaskGroup(of: (Int, Media?).self) { group in
            for id in ids {
                group.addTask {
                    do {
                        let movie = try await Self.networkClient.request(TMDB.MovieDetails(movieID: id))
                        return (id, Media(movie: movie))
                    } catch {
                        return (id, nil)
                    }
                }
            }

            var moviesDict: [Int: Media] = [:]
            for try await (id, movie) in group {
                if let movie = movie {
                    moviesDict[id] = movie
                }
            }

            // Maintain original order
            return ids.compactMap { moviesDict[$0] }
        }
    }
}
