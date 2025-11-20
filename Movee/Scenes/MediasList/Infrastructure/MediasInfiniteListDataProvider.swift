//
//  MediasInfiniteListDataProvider.swift
//  Movee
//
//  Created by user on 11/18/25.
//

protocol MediasInfiniteListDataProvider: InfiniteListDataProvider where Item == Media { }

extension PagedDataSource<Media>: MediasInfiniteListDataProvider { }

extension SwiftDataWatchlistRepository: MediasInfiniteListDataProvider {
    var items: [Media] {
        watchlist.map { .init($0.media) }
    }
    
    var hasMorePages: Bool {
        false
    }
    
    func fetch() {}
    func refresh() {}
}
