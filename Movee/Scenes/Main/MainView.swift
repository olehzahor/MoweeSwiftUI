//
//  MainView.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ExploreView()
                .tabItem {
                    Label("Explore", systemImage: "house")
                }
            MediasListView(section: .watchlistSection)
                .tabItem {
                    Label("Watchlist", systemImage: "list.and.film")
                }
            SearchView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    MainView()
}
