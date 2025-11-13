////
////  Section.swift
////  Movee
////
////  Created by user on 4/8/25.
////
//
//import Combine
//
//struct MediasSection {
//    typealias PublisherBuilder = (Int) -> AnyPublisher<PaginatedResponse<Media>, Error>
//    
//    struct Placeholder {
//        let title: String
//        let subtitle: String?
//    }
//    
//    let title: String
//    let fullTitle: String?
//    let placeholder: Placeholder?
//    let publisherBuilder: PublisherBuilder?
//    
//    init(title: String, fullTitle: String? = nil, placeholder: Placeholder? = nil, publisherBuilder: PublisherBuilder? = nil) {
//        self.title = title
//        self.fullTitle = fullTitle
//        self.placeholder = placeholder
//        self.publisherBuilder = publisherBuilder
//    }
//}
//
//extension MediasSection {
//    static var watchlistSection = MediasSection(
//        title: "Watchlist",
//        placeholder: .init(
//            title: "Your watchlist is empty",
//            subtitle: "Movies and TV Shows you add to your watchlist will appear here")) { _ in
//        WatchlistManager.shared.itemsPublisher
//            .map { PaginatedResponse(page: 1, results: $0.map({ .init($0.media) }), total_pages: 1, total_results: $0.count) }
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//    }
//}
//
//extension Array where Element == MediasSection {
//    static var homePageSections: [MediasSection] = [
//        MediasSection(title: "Popular Movies", publisherBuilder: { page in
//            TMDBAPIClient.shared.fetchPopularMovies(page: page)
//                .map { $0.map { Media(movie: $0) } }
//                .eraseToAnyPublisher()
//        }),
////        MediasSection(title: "Now Playing Movies", publisherBuilder: { page in
////            TMDBAPIClient.shared.fetchNowPlayingMovies(page: page)
////                .map { $0.map { Media(movie: $0) } }
////                .eraseToAnyPublisher()
////        }),
////        MediasSection(title: "Upcoming Movies", publisherBuilder: { page in
////            TMDBAPIClient.shared.fetchUpcomingMovies(page: page)
////                .map { $0.map { Media(movie: $0) } }
////                .eraseToAnyPublisher()
////        }),
////        MediasSection(title: "Top Rated Movies", publisherBuilder: { page in
////            TMDBAPIClient.shared.fetchTopRatedMovies(page: page)
////                .map { $0.map { Media(movie: $0) } }
////                .eraseToAnyPublisher()
////        }),
//        MediasSection(title: "Popular TV Shows", publisherBuilder: { page in
//            TMDBAPIClient.shared.fetchPopularTVShows(page: page)
//                .map { $0.map { Media(tvShow: $0) } }
//                .eraseToAnyPublisher()
//        }),
////        MediasSection(title: "Top Rated TV Shows", publisherBuilder: { page in
////            TMDBAPIClient.shared.fetchTopRatedTVShows(page: page)
////                .map { $0.map { Media(tvShow: $0) } }
////                .eraseToAnyPublisher()
////        }),
////        MediasSection(title: "On The Air TV Shows", publisherBuilder: { page in
////            TMDBAPIClient.shared.fetchOnTheAirTVShows(page: page)
////                .map { $0.map { Media(tvShow: $0) } }
////                .eraseToAnyPublisher()
////        }),
////        MediasSection(title: "Airing Today TV Shows", publisherBuilder: { page in
////            TMDBAPIClient.shared.fetchAiringTodayTVShows(page: page)
////                .map { $0.map { Media(tvShow: $0) } }
////                .eraseToAnyPublisher()
////        })
//    ]
//}
//
//// MARK: - Hashable and Identifiable conformance
//extension MediasSection: Hashable, Identifiable {
//    var id: String { title }
//    
//    static func == (lhs: MediasSection, rhs: MediasSection) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//}
