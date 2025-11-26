//
//  SearchView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.coordinator) private var coordinator

    @State private var query: String = ""
    @State private var isSearchActive: Bool = false
    @State private var selectedScope: SearchScope = .all

    var body: some View {
        Group {
            if !query.isEmpty {
                SearchResultsView(query: query, scope: selectedScope)
            } else {
                CollectionView()
            }
        }
        .searchable(
            text: $query,
            isPresented: $isSearchActive,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Movies, TV shows, people"
        )
        .searchScopes($selectedScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue).tag(scope)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    coordinator?.push(.advancedSearch)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    coordinator?.push(.searchHistory)
                } label: {
                    Image(systemName: "clock.arrow.circlepath")
                }
            }
        }
    }
}
