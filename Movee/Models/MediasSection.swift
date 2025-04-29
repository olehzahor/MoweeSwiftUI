//
//  Section.swift
//  Movee
//
//  Created by user on 4/8/25.
//

import Combine

struct MediasSection {
    let title: String
    let fullTitle: String?
    let publisherBuilder: (Int) -> AnyPublisher<PaginatedResponse<Media>, Error>
    
    init(title: String, fullTitle: String? = nil, publisherBuilder: @escaping (Int) -> AnyPublisher<PaginatedResponse<Media>, Error>) {
        self.title = title
        self.fullTitle = fullTitle
        self.publisherBuilder = publisherBuilder
    }
}

extension Array where Element == MediasSection {
    static var homePageSections: [MediasSection] = [
        MediasSection(title: "Watchlist", publisherBuilder: { _ in
            WatchlistManager.shared.itemsPublisher
                .map { PaginatedResponse(page: 1, results: $0.map({ $0.media }), total_pages: 1, total_results: $0.count) }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }),
        MediasSection(title: "Popular", publisherBuilder: { page in
            TMDBAPIClient.shared.fetchPopularMovies(page: page)
                .map { $0.map { Media(movie: $0) } }
                .eraseToAnyPublisher()
        }),
//        MediasSection(title: "Now playing", publisherBuilder: { page in
//            TMDBAPIClient.shared.fetchNowPlayingMovies(page: page)
//                .map { $0.map { Media(movie: $0) } }
//                .eraseToAnyPublisher()
//        }),
//        MediasSection(title: "Upcoming", publisherBuilder: { page in
//            TMDBAPIClient.shared.fetchUpcomingMovies(page: page)
//                .map { $0.map { Media(movie: $0) } }
//                .eraseToAnyPublisher()
//        }),
//        MediasSection(title: "Top rated", publisherBuilder: { page in
//            TMDBAPIClient.shared.fetchTopRatedMovies(page: page)
//                .map { $0.map { Media(movie: $0) } }
//                .eraseToAnyPublisher()
//        }),
        MediasSection(title: "Popular TV Shows", publisherBuilder: { page in
            TMDBAPIClient.shared.fetchPopularTVShows(page: page)
                .map { $0.map { Media(tvShow: $0) } }
                .eraseToAnyPublisher()
        })
    ]
}

// MARK: - Hashable and Identifiable conformance
extension MediasSection: Hashable, Identifiable {
    var id: String { title }
    
    static func == (lhs: MediasSection, rhs: MediasSection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
