//
//  NewMediasSection.swift
//  Movee
//
//  Created by Oleh on 29.10.2025.
//

struct Dependencies {
    static let networkClient = NetworkClient2(
        interceptors: [
            TMDBInterceptor(),
            LoggingInterceptor(logger: Logger.shared)
        ],
        decoder: TMDBJSONDecoder()
    )
}

struct NewMediasSection {
    struct Placeholder {
        let title: String
        let subtitle: String?
    }
    
    let title: String
    let fullTitle: String?
    let placeholder: Placeholder?
    let dataProvider: MediasListDataProvider?
    
    init(title: String, fullTitle: String? = nil, placeholder: Placeholder? = nil, dataProvider: MediasListDataProvider? = nil) {
        self.title = title
        self.fullTitle = fullTitle
        self.placeholder = placeholder
        self.dataProvider = dataProvider
    }
}

extension Array where Element == NewMediasSection {
    static var homePageSections: [NewMediasSection] = [
        NewMediasSection(title: "Popular Movies", dataProvider: MoviesListDataProvider.popular),
        NewMediasSection(title: "Now Playing Movies", dataProvider: MoviesListDataProvider.nowPlaying),
        NewMediasSection(title: "Upcoming Movies", dataProvider: MoviesListDataProvider.upcoming),
        NewMediasSection(title: "Top Rated Movies", dataProvider: MoviesListDataProvider.topRated),
        NewMediasSection(title: "Popular TV Shows", dataProvider: TVShowsListDataProvider.popular),
        NewMediasSection(title: "Top Rated TV Shows", dataProvider: TVShowsListDataProvider.topRated),
        NewMediasSection(title: "On The Air TV Shows", dataProvider: TVShowsListDataProvider.onTheAir),
        NewMediasSection(title: "Airing Today TV Shows", dataProvider: TVShowsListDataProvider.airingToday),
    ]
}

extension NewMediasSection: Hashable, Identifiable {
    var id: String { title }
    
    static func == (lhs: NewMediasSection, rhs: NewMediasSection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/*
struct RelatedMediasSectionDataProvider: MediasListDataProvider {
    private let networkClient = NetworkClient2(
        interceptors: [
            TMDBInterceptor(),
            LoggingInterceptor(logger: Logger.shared)
        ],
        decoder: TMDBJSONDecoder()
    )

    let identifier: MediaIdentifier
    
    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        switch identifier.type {
        case .movie:
            let request = TMDB.MovieRecommendations(movieID: identifier.id, page: page)
            return try await networkClient.request(request).map { Media(movie: $0) }
        case .tvShow:
            let request = TMDB.TVShowRecommendations(tvShowID: identifier.id, page: page)
            return try await networkClient.request(request).map { Media(tvShow: $0) }
        }
    }
}
*/
