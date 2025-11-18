//
//  WatchlistManager.swift
//  Movee
//
//  Created by user on 4/21/25.
//

import SwiftData
import Foundation
import Combine
import SwiftUI

@MainActor
protocol WatchlistRepository {
    var items: [WatchlistItem] { get }
    
    func add(_ media: Media) async
    func remove(_ media: Media) async
    func toggle(_ media: Media) async
    func contains(_ mediaID: Int) async -> Bool
}

@MainActor @Observable
final class SwiftDataWatchlistRepository: WatchlistRepository {
    private let logger: WatchlistLogger?
    private let dataService: SwiftDataService<WatchlistItem>
    
    private(set) var items: [WatchlistItem] = []
    
    private func fetchAndSendItems() async {
        do {
            items = try await dataService.fetch()
        } catch {
            logger?.logWatchlistError("Failed to fetch watchlist items: \(error)")
        }
    }
    
    func add(_ media: Media) async {
        do {
            let item = WatchlistItem(media: .init(media))
            try await dataService.create(item)
            logger?.logWatchlistInfo("Successfully added \(media.title) (\(media.id)) to watchlist")
            await fetchAndSendItems()
        } catch {
            logger?.logWatchlistError("Failed to add watchlist items: \(error)")
        }
    }
    
    func remove(_ media: Media) async {
        do {
            let predicate = #Predicate<WatchlistItem> { $0.media.id == media.id }
            let items = try await dataService.fetch(predicate: predicate)
            for item in items {
                try await dataService.delete(item)
            }
            logger?.logWatchlistInfo("Successfully removed \(media.title) (\(media.id)) from watchlist")
            await fetchAndSendItems()
        } catch {
            logger?.logWatchlistError("Failed to remove watchlist items: \(error)")
        }
    }
    
    func contains(_ mediaID: Int) async -> Bool {
        do {
            let predicate = #Predicate<WatchlistItem> { $0.media.id == mediaID }
            let items = try await dataService.fetch(predicate: predicate)
            let exists = !items.isEmpty
            logger?.logWatchlistInfo("Checked watchlist for (\(mediaID)): \(exists)")
            return exists
        } catch {
            logger?.logWatchlistError("Failed to check watchlist: \(error)")
            return false
        }
    }
    
    func toggle(_ media: Media) async {
        if await contains(media.id) {
            await remove(media)
        } else {
            await add(media)
        }
    }
    
    nonisolated init(logger: WatchlistLogger?, dataService: SwiftDataService<WatchlistItem> = SwiftDataService<WatchlistItem>(modelContainer: AppContainer.shared)) {
        self.logger = logger
        self.dataService = dataService
        Task { @MainActor in
            await fetchAndSendItems()
        }
    }
}

public protocol WatchlistLogger {
    func logWatchlistInfo(_ message: String)
    func logWatchlistError(_ message: String)
}

extension Logger: WatchlistLogger {
    public func logWatchlistInfo(_ message: String) {
        log(message, level: .info)
    }
    
    public func logWatchlistError(_ message: String) {
        log(message, level: .error)
    }
}
