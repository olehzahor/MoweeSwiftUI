//
//  WatchlistView.swift
//  Movee
//
//  Created by user on 11/17/25.
//

import SwiftUI
import Factory

struct WatchlistView: View {
    private let repository: SwiftDataWatchlistRepository = Container.shared.watchlistRepository()

    private var emptyState: some View {
        ContentUnavailableView(
            "Your watchlist is empty",
            systemImage: "bookmark.slash",
            description: Text("Movies and TV Shows you add to your watchlist will appear here")
        )
    }

    private var mediaList: some View {
        List(repository.items) { item in
            NavigationLink {
                MediaDetailsView(media: Media(item.media))
            } label: {
                MediaRowView(data: .init(media: Media(item.media)))
            }
            .listRowSeparator(.hidden)
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    Task {
                        await repository.remove(Media(item.media))
                    }
                } label: {
                    Label("Remove", systemImage: "trash")
                }
            }
        }
        .listStyle(.plain)
    }
    
    var body: some View {
        Group {
            if repository.items.isEmpty {
                emptyState
            } else {
                mediaList
            }
        }
        .navigationTitle("Watchlist")
        .navigationBarTitleDisplayMode(.large)
    }
}
