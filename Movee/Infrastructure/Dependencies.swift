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
    // MARK: - Network Client
    var networkClient: Factory<NetworkClient2> {
        self { NetworkClient2() }
            .singleton
    }
    
    // MARK: - Watchlist Repository
    var watchlistRepository: Factory<SwiftDataWatchlistRepository> {
        self { SwiftDataWatchlistRepository() }
            .singleton
    }
}
