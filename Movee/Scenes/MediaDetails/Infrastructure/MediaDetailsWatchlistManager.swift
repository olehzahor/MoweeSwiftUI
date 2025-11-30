//
//  MediaDetailsWatchlistManager.swift
//  Movee
//
//  Created by user on 11/13/25.
//

import Foundation

@MainActor protocol MediaDetailsWatchlistManager {
    var isInWatchlist: Bool? { get }
    func toggleWatchlist()
}

extension WatchlistButton {
    init(watchlistManager: MediaDetailsWatchlistManager) {
        self.init(
            isInWatchlist: watchlistManager.isInWatchlist,
            action: watchlistManager.toggleWatchlist
        )
    }
}
