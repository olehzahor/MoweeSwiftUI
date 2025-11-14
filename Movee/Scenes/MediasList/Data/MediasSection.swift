//
//  MediasSection.swift
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

struct MediasSection {
    // TODO: add id
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

extension Array where Element == MediasSection {
    static var homePageSections: [MediasSection] = [
        MediasSection(title: "Popular Movies", dataProvider: MoviesListDataProvider.popular),
        MediasSection(title: "Now Playing Movies", dataProvider: MoviesListDataProvider.nowPlaying),
        MediasSection(title: "Upcoming Movies", dataProvider: MoviesListDataProvider.upcoming),
        MediasSection(title: "Top Rated Movies", dataProvider: MoviesListDataProvider.topRated),
        MediasSection(title: "Popular TV Shows", dataProvider: TVShowsListDataProvider.popular),
        MediasSection(title: "Top Rated TV Shows", dataProvider: TVShowsListDataProvider.topRated),
        MediasSection(title: "On The Air TV Shows", dataProvider: TVShowsListDataProvider.onTheAir),
        MediasSection(title: "Airing Today TV Shows", dataProvider: TVShowsListDataProvider.airingToday),
    ]
}

extension MediasSection: Hashable, Identifiable {
    var id: String { title }

    static func == (lhs: MediasSection, rhs: MediasSection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
