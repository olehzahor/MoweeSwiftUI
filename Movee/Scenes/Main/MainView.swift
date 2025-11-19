//
//  MainView.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUI
import Factory

struct MainView: View {
    @StateObject private var exploreCoordinator = AppCoordinator()
    @StateObject private var watchlistCoordinator = AppCoordinator()
    @StateObject private var discoverCoordinator = AppCoordinator()

    var body: some View {
        TabView {
            Tab("Explore", systemImage: "house") {
                CoordinatedNavigationStack(coordinator: exploreCoordinator) {
                    ExploreView()
                }
            }

            Tab("Watchlist", systemImage: "list.and.film") {
                CoordinatedNavigationStack(coordinator: watchlistCoordinator) {
                    MediasListView(.watchlist())
                }
            }

            Tab("Discover", systemImage: "magnifyingglass", role: .search) {
                CoordinatedNavigationStack(coordinator: discoverCoordinator) {
                    NewSearchView()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
