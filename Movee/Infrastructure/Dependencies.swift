//
//  Dependencies.swift
//  Movee
//
//  Created by user on 11/16/25.
//

import Foundation
import Factory

// MARK: - Factory Container
extension Container {
    // MARK: - Logger
    var logger: Factory<Logger> {
        self { Logger() }
            .singleton
    }

    // MARK: - Network Client
    var networkClient: Factory<NetworkClient> {
        self { NetworkClient() }
            .singleton
    }
    
    // MARK: - Watchlist Repository
    var watchlistRepository: Factory<SwiftDataWatchlistRepository> {
        self { SwiftDataWatchlistRepository(logger: self.logger.resolve()) }
            .singleton
    }

    // MARK: - Search History Repository
    var searchHistoryRepository: Factory<SwiftDataSearchHistoryRepository> {
        self { SwiftDataSearchHistoryRepository(logger: self.logger.resolve()) }
            .singleton
    }
}
