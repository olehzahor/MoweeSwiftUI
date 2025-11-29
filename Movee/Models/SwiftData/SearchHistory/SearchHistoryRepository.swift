//
//  SearchHistoryRepository.swift
//  Movee
//
//  Created by user on 5/15/25.
//

import Foundation
import SwiftData
import Combine

@MainActor
protocol SearchHistoryRepository {
    var searchHistory: [SearchHistoryItem] { get }

    func add(_ media: Media) async
    func remove(_ media: Media) async
    func contains(_ mediaID: Int) async -> Bool
}

@MainActor @Observable
final class SwiftDataSearchHistoryRepository: SearchHistoryRepository {
    private let logger: SearchHistoryLogger?
    private let dataService: SwiftDataService<SearchHistoryItem>

    private(set) var searchHistory: [SearchHistoryItem] = []
    private(set) var loadState: LoadState = .idle

    private func fetchAndSendItems() async {
        do {
            loadState = .loading
            searchHistory = try await dataService.fetch(sort: [SortDescriptor(\SearchHistoryItem.added, order: .reverse)])
            loadState = .loaded(isEmpty: searchHistory.isEmpty)
        } catch {
            loadState = .error(error)
            logger?.logSearchHistoryError("Failed to fetch search history items: \(error)")
        }
    }

    func add(_ media: Media) async {
        do {
            let stored = StoredMedia(media)
            let item = SearchHistoryItem(media: stored)
            try await dataService.create(item)
            logger?.logSearchHistoryInfo("Successfully added \(media.title) (\(media.id)) to search history")
            await fetchAndSendItems()
        } catch {
            logger?.logSearchHistoryError("Failed to add search history item: \(error)")
        }
    }

    func remove(_ media: Media) async {
        do {
            let predicate = #Predicate<SearchHistoryItem> { $0.media.id == media.id }
            let itemsToDelete = try await dataService.fetch(predicate: predicate)

            searchHistory.removeAll { $0.media.id == media.id }

            for item in itemsToDelete {
                try await dataService.delete(item)
            }
            logger?.logSearchHistoryInfo("Successfully removed \(media.title) (\(media.id)) from search history")
            await fetchAndSendItems()
        } catch {
            logger?.logSearchHistoryError("Failed to remove search history item: \(error)")
        }
    }

    func contains(_ mediaID: Int) async -> Bool {
        do {
            let predicate = #Predicate<SearchHistoryItem> { $0.media.id == mediaID }
            let items = try await dataService.fetch(predicate: predicate)
            let exists = !items.isEmpty
            logger?.logSearchHistoryInfo("Checked search history for (\(mediaID)): \(exists)")
            return exists
        } catch {
            logger?.logSearchHistoryError("Failed to check search history: \(error)")
            return false
        }
    }

    nonisolated init(logger: SearchHistoryLogger?, dataService: SwiftDataService<SearchHistoryItem> = SwiftDataService<SearchHistoryItem>(modelContainer: AppContainer.shared)) {
        self.logger = logger
        self.dataService = dataService

        Task { @MainActor in
            await fetchAndSendItems()
        }
    }
}

@MainActor
public protocol SearchHistoryLogger: Sendable {
    func logSearchHistoryInfo(_ message: String)
    func logSearchHistoryError(_ message: String)
}

extension Logger: SearchHistoryLogger {
    public func logSearchHistoryInfo(_ message: String) {
        log(message, level: .info)
    }

    public func logSearchHistoryError(_ message: String) {
        log(message, level: .error)
    }
}
