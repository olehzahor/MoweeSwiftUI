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
            Tab("Explore", systemImage: "house") {
                ExploreView()
            }
            
            Tab("Watchlist", systemImage: "list.and.film") {
                MediasListView(section: .watchlist)
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
