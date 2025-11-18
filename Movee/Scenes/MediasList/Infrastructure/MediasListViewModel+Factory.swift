//
//  MediasListViewModel+Factory.swift
//  Movee
//
//  Created by user on 11/18/25.
//

import Factory

extension MediasListViewModel {
    static func section(_ section: MediasSection) -> Self {
        let title = section.fullTitle ?? section.title
        let dataSource = PagedDataSource<Media>.pageNumber { [section] page in
            guard let dataProvider = section.dataProvider else {
                throw MediasSectionError.noDataProvider
            }
            return try await dataProvider.fetch(page: page)
        }
        return Self(dataSource, title: title, largeTitle: false, emptyState: .search)
    }
    
    static func watchlist(_ repo: WatchlistRepository = Container.shared.watchlistRepository()) -> Self {
        Self(
            StoredItemsListDataProvider(
                items: repo.items.map { Media($0.media) }
            ),
            title: "Watchlist",
            largeTitle: true,
            emptyState: .watchlist) { media in
                Task { await repo.remove(media) }
            }
    }
}
