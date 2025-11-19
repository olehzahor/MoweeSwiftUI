//
//  MainView.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUI
import Factory

struct MainView: View {
    @StateObject private var coordinator = Container.shared.coordinator()

    var body: some View {
        TabView {
            Tab("Explore", systemImage: "house") {
                NavigationStack(path: $coordinator.path) {
                    ExploreView()
                        .coordinated(with: coordinator)
                }
            }

            Tab("Watchlist", systemImage: "list.and.film") {
                NavigationStack(path: $coordinator.path) {
                    MediasListView(.watchlist())
                }
            }

            Tab("Discover", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    NewSearchView()
                }
                .navigationDestination(for: Media.self) { media in
                    MediaDetailsView(media: media)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
