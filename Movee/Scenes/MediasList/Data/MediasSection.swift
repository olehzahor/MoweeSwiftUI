//
//  MediasSection.swift
//  Movee
//
//  Created by Oleh on 29.10.2025.
//

import Factory

struct MediasSection {
    struct EmptyState {
        let title: String
        let subtitle: String?
    }
    
    let title: String
    let fullTitle: String?
    let emptyState: EmptyState?
    let dataProvider: MediasListDataProvider?
    
    init(title: String, fullTitle: String? = nil, emptyState: EmptyState? = nil, dataProvider: MediasListDataProvider? = nil) {
        self.title = title
        self.fullTitle = fullTitle
        self.emptyState = emptyState
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

extension MediasSection {
    static var watchlist = MediasSection(
        title: "Watchlist",
        emptyState: .init(
            title: "Your watchlist is empty",
            subtitle: "Movies and TV Shows you add to your watchlist will appear here"),
        dataProvider: CustomMediasListDataProvider { @MainActor _ in
            let items = Container.shared.watchlistRepository().items
            let medias = items.map { Media($0.media) }
            return .wrap(medias)
        }
    )
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
