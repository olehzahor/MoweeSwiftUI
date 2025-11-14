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
                TestExploreView()
            }
            
            Tab("Watchlist", systemImage: "list.and.film") {
                //MediasListView(section: .watchlistSection)
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
