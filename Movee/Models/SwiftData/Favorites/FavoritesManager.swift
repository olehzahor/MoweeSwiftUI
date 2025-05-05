
//
//  FavoritesManager.swift
//  Movee
//
//  Created by user on 5/5/25.
//

import SwiftData
import Foundation
import Combine
import SwiftUI

protocol FavoritesManagerInterface {
    func addToFavorites(_ media: Media) async
    func removeFromFavorites(_ media: Media) async
    func isFavorite(_ media: Media) async -> Bool
    func toggleFavorite(_ media: Media) async
    var itemsPublisher: AnyPublisher<[FavoriteMedia], Never> { get }
}

class FavoritesManager: FavoritesManagerInterface {
    static let shared = FavoritesManager()

    private let dataService = SwiftDataService<FavoriteMedia>(modelContainer: AppContainer.shared)
    private let itemsSubject = CurrentValueSubject<[FavoriteMedia], Never>([])

    /// Publisher for observing all favorite media items.
    var itemsPublisher: AnyPublisher<[FavoriteMedia], Never> {
        itemsSubject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    /// Fetches all items from storage and emits them.
    private func fetchAndSendItems() async {
        do {
            let items = try await dataService.fetch()
            await MainActor.run {
                itemsSubject.send(items)
            }
        } catch {
            Logger.shared.log("Failed to fetch favorite items: \(error)", level: .error)
        }
    }

    func addToFavorites(_ media: Media) async {
        do {
            let item = FavoriteMedia(media: .init(media))
            try await dataService.create(item)
            Logger.shared.log("Added to favorites: \(media.title) (\(media.id))", level: .info)
            await fetchAndSendItems()
        } catch {
            Logger.shared.log("Failed to add favorite: \(error)", level: .error)
        }
    }

    func removeFromFavorites(_ media: Media) async {
        do {
            let predicate = #Predicate<FavoriteMedia> { $0.media.id == media.id }
            let items = try await dataService.fetch(predicate: predicate)
            for item in items {
                try await dataService.delete(item)
            }
            Logger.shared.log("Removed from favorites: \(media.title) (\(media.id))", level: .info)
            await fetchAndSendItems()
        } catch {
            Logger.shared.log("Failed to remove favorite: \(error)", level: .error)
        }
    }

    func isFavorite(_ media: Media) async -> Bool {
        do {
            let predicate = #Predicate<FavoriteMedia> { $0.media.id == media.id }
            let items = try await dataService.fetch(predicate: predicate)
            let exists = !items.isEmpty
            Logger.shared.log("Is favorite check for \(media.title) (\(media.id)): \(exists)", level: .info)
            return exists
        } catch {
            Logger.shared.log("Failed to check favorite: \(error)", level: .error)
            return false
        }
    }

    func toggleFavorite(_ media: Media) async {
        if await isFavorite(media) {
            await removeFromFavorites(media)
        } else {
            await addToFavorites(media)
        }
    }

    private init() {
        Task { [weak self] in
            await self?.fetchAndSendItems()
        }
    }
}

