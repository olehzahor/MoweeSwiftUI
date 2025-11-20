//
//  NewSearchView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI
import Combine

@MainActor @Observable
final class SearchResultsViewModel {
    private let repo: SearchResultsRepositoryProtocol
    private(set) var query: String

    private(set) var dataSource: PagedDataSource<SearchResult>

    @ObservationIgnored
    private var debounceTask: Task<Void, Never>?

    func update(query: String) {
        debounceTask?.cancel()

        debounceTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }

            self.query = query
            self.dataSource = .pageNumber { [repo] page in
                return try await repo.search(query, page: page)
            }
            self.dataSource.fetch()
        }
    }

    init(query: String, repo: SearchResultsRepositoryProtocol = SearchResultsRepository()) {
        self.query = query
        self.repo = repo
        self.dataSource = .pageNumber { page in
            return try await repo.search(query, page: page)
        }
    }
}

struct SearchResultsView: View {
    @Environment(\.coordinator) private var coordinator
    @State private var viewModel: SearchResultsViewModel
    
    private var query: String

    private var emptyState: some View {
        ContentUnavailableView(.search)
    }

    var body: some View {
        InfiniteList(viewModel.dataSource) { result in
            switch result.result {
            case .movie(let movie):
                MediaRowView(data: .init(media: Media(movie: movie)))
            case .tv(let tvShow):
                MediaRowView(data: .init(media: Media(tvShow: tvShow)))
            case .person(let person):
                PersonRowView(person: .init(person: person))
            }
        } placeholder: {
            MediaRowView()
                .loading(true)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .onChange(of: query) { oldValue, newValue in
            viewModel.update(query: newValue)
        }
    }

    init(query: String) {
        self.query = query
        self.viewModel = SearchResultsViewModel(query: query)
    }
}

struct NewSearchView: View {
    @State private var query: String = ""
    @State private var isSearchActive: Bool = false

    var body: some View {
        Group {
            if !query.isEmpty {
                SearchResultsView(query: query)
                    //.id(query)
            } else {
                ContentUnavailableView(
                    "Search",
                    systemImage: "magnifyingglass",
                    description: Text("Search for movies, TV shows, and people")
                )
            }
        }
        .searchable(
            text: $query,
            isPresented: $isSearchActive,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Movies, TV shows, people"
        )
    }
}

#Preview {
    SearchResultsView(query: "Avatar")
}
