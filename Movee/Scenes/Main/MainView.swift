//
//  MainView.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUI
import Factory

struct MainView: View {
    let items = Container.shared.watchlistRepository().items
    
    var body: some View {
        TabView {
            Tab("Explore", systemImage: "house") {
                NavigationStack {
                    ExploreView()
                }
            }
            
            Tab("Watchlist", systemImage: "list.and.film") {
                NavigationStack {
                    WatchlistView()
                }
            }
            
            Tab("Discover", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    NewSearchView()
                }
                //.navigationBarTitleDisplayMode(.automatic)
            }
        }
    }
}

#Preview {
    MainView()
}
