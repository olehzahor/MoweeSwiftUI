//
//  SearchHistoryManager.swift
//  Movee
//
//  Created by user on 5/15/25.
//

import Foundation
import SwiftData
import Combine

@MainActor
protocol SearchHistoryManager {
    func addToHistory(_ media: Media) async
    func removeFromHistory(_ media: Media) async
    var itemsPublisher: AnyPublisher<[SearchHistoryItem], Never> { get }
}

@MainActor @Observable
final class SwiftDataSearchHistoryManager: SearchHistoryManager {
    //static let shared = SearchHistoryManager()

    private let dataService = SwiftDataService<SearchHistoryItem>(modelContainer: AppContainer.shared)
    private let itemsSubject = CurrentValueSubject<[SearchHistoryItem], Never>([])

    var itemsPublisher: AnyPublisher<[SearchHistoryItem], Never> {
        itemsSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

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

    func count() -> Int {
        itemsSubject.value.count
    }

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
    
    nonisolated init() {
        Task { [weak self] in
            await self?.reloadItems()
        }
    }
}
