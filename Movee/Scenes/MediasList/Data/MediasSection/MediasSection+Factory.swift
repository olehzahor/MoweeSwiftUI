//
//  MediasSection+Factory.swift
//  Movee
//
//  Created by user on 11/17/25.
//

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

extension Array where Element == MediasSection {
    static var appStoreHomePageSections: [MediasSection] = [
        MediasSection(title: "Popular Movies", dataProvider: ScreenshotsMediasListDataProvider(offset: 0)),
        MediasSection(title: "Now Playing Movies", dataProvider: ScreenshotsMediasListDataProvider(offset: 4)),
        MediasSection(title: "Upcoming Movies", dataProvider: ScreenshotsMediasListDataProvider(offset: 8)),
    ]
}
