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
    private let dataService = SwiftDataService<WatchlistItem>(modelContainer: AppContainer.shared)
    
    private(set) var items: [WatchlistItem] = []

    private func fetchAndSendItems() async {
        do {
            items = try await dataService.fetch()
        } catch {
            Logger.shared.log("Failed to fetch watchlist items: \(error)", level: .error)
        }
    }
    
    func add(_ media: Media) async {
        do {
            let item = WatchlistItem(media: .init(media))
            try await dataService.create(item)
            Logger.shared.log("Successfully added \(media.title) (\(media.id)) to watchlist", level: .info)
            await fetchAndSendItems()
        } catch {
            Logger.shared.log("Failed to add watchlist items: \(error)", level: .error)
        }
    }
    
    func remove(_ media: Media) async {
        do {
            let predicate = #Predicate<WatchlistItem> { $0.media.id == media.id }
            let items = try await dataService.fetch(predicate: predicate)
            for item in items {
                try await dataService.delete(item)
            }
            Logger.shared.log("Successfully removed \(media.title) (\(media.id)) from watchlist", level: .info)
            await fetchAndSendItems()
        } catch {
            Logger.shared.log("Failed to remove watchlist items: \(error)", level: .error)
        }
    }
        
    func contains(_ mediaID: Int) async -> Bool {
        do {
            let predicate = #Predicate<WatchlistItem> { $0.media.id == mediaID }
            let items = try await dataService.fetch(predicate: predicate)
            let exists = !items.isEmpty
            Logger.shared.log("Checked watchlist for (\(mediaID)): \(exists)", level: .info)
            return exists
        } catch {
            Logger.shared.log("Failed to check watchlist: \(error)", level: .error)
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
    
    nonisolated init() {
        Task { @MainActor in
            await fetchAndSendItems()
        }
    }
}
