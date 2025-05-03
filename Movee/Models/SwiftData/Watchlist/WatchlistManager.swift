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

protocol WatchlistManagerInterface {
    func addToWatchlist(_ media: Media) async
    func removeFromWatchlist(_ media: Media) async
    func isInWatchlist(_ media: Media) async -> Bool
}

class WatchlistManager: WatchlistManagerInterface {
    static let shared = WatchlistManager()
    
    private let dataService = SwiftDataService<WatchlistItem>(modelContainer: AppContainer.shared)
    private let itemsSubject = CurrentValueSubject<[WatchlistItem], Never>([])

    private func fetchAndSendItems() async {
        do {
            let items = try await dataService.fetch()
            await MainActor.run {
                itemsSubject.send(items)
            }
        } catch {
            Logger.shared.log("Failed to fetch watchlist items: \(error)", level: .error)
        }
    }
    
    var itemsPublisher: AnyPublisher<[WatchlistItem], Never> {
        itemsSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func addToWatchlist(_ media: Media) async {
        do {
            let item = WatchlistItem(media: media)
            try await dataService.create(item)
            Logger.shared.log("Successfully added \(media.title) (\(media.id)) to watchlist", level: .info)
            await fetchAndSendItems()
        } catch {
            Logger.shared.log("Failed to add watchlist items: \(error)", level: .error)
        }
    }
    
    func removeFromWatchlist(_ media: Media) async {
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
    
    func isInWatchlist(_ media: Media) async -> Bool {
        do {
            let predicate = #Predicate<WatchlistItem> { $0.media.id == media.id }
            let items = try await dataService.fetch(predicate: predicate)
            let exists = !items.isEmpty
            Logger.shared.log("Checked watchlist for \(media.title) (\(media.id)): \(exists)", level: .info)
            return exists
        } catch {
            Logger.shared.log("Failed to check watchlist: \(error)", level: .error)
            return false
        }
    }

    /// Toggles the watchlist state: adds if not present, removes if present.
    func toggleWatchlist(_ media: Media) async {
        if await isInWatchlist(media) {
            await removeFromWatchlist(media)
        } else {
            await addToWatchlist(media)
        }
    }
    
    private init() {
        Task { [weak self] in
            await self?.fetchAndSendItems()
        }
    }
}
