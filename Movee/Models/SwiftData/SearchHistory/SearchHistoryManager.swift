//
//  SearchHistoryManager.swift
//  Movee
//
//  Created by user on 5/15/25.
//

import Foundation
import SwiftData
import Combine

/// Defines the public interface for managing search history.
protocol SearchHistoryManagerInterface {
    func addToHistory(_ media: Media) async
    func removeFromHistory(_ media: Media) async
    var itemsPublisher: AnyPublisher<[SearchHistoryItem], Never> { get }
}

/// Manages persisting and observing search history items.
final class SearchHistoryManager: SearchHistoryManagerInterface {
    static let shared = SearchHistoryManager()

    private let dataService = SwiftDataService<SearchHistoryItem>(modelContainer: AppContainer.shared)
    private let itemsSubject = CurrentValueSubject<[SearchHistoryItem], Never>([])

    /// Emits the current list of history items on the main thread.
    var itemsPublisher: AnyPublisher<[SearchHistoryItem], Never> {
        itemsSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private init() {
        Task { [weak self] in
            await self?.reloadItems()
        }
    }

    /// Adds a new entry for the given media.
    func addToHistory(_ media: Media) async {
        do {
            let stored = StoredMedia(media)
            let item = SearchHistoryItem(media: stored)
            try await dataService.create(item)
            Logger.shared.log("Added \(media.id) to search history", level: .info)
            await reloadItems()
        } catch {
            Logger.shared.log("Failed to add to search history: \(error)", level: .error)
        }
    }

    /// Removes all history entries matching the given media.
    func removeFromHistory(_ media: Media) async {
        do {
            let predicate = #Predicate<SearchHistoryItem> { $0.media.id == media.id }
            let items = try await dataService.fetch(predicate: predicate)
            for item in items {
                try await dataService.delete(item)
            }
            Logger.shared.log("Removed \(media.id) from search history", level: .info)
            await reloadItems()
        } catch {
            Logger.shared.log("Failed to remove from search history: \(error)", level: .error)
        }
    }

    /// Returns the current number of search history items from the in-memory cache.
    func count() -> Int {
        itemsSubject.value.count
    }

    /// Fetches the current items and emits them via the publisher.
    private func reloadItems() async {
        do {
            let items = try await dataService.fetch()
            await MainActor.run {
                itemsSubject.send(items)
            }
        } catch {
            Logger.shared.log("Failed to fetch search history: \(error)", level: .error)
        }
    }
}
