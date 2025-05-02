//
//  SearchView.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUI
import Combine

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    @ViewBuilder
    private func destinationView(for result: SearchResult) -> some View {
        switch viewModel.getNavigationDestination(for: result) {
        case .media(let media):
            MediaDetailsView(media: media)
        case .person(let person):
            PersonDetailsView(person: person)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.results) { result in
                    NavigationLink {
                        destinationView(for: result)
                    } label: {
                        MediaRowView(data: .init(searchResult: result))
                    }.transaction { $0.animation = nil }
                }
            }
            .animation(.default, value: viewModel.results)
            .listStyle(.plain)
            .searchable(text: $viewModel.query, prompt: "Search movies, TV shows, people")
            .navigationTitle("Search")
        }
    }
}

// MARK: - ViewModel

private class SearchViewModel: ObservableObject {
    enum NavigationDestination {
        case media(Media)
        case person(MediaPerson)
    }
    
    @Published var query: String = ""
    @Published var results: [SearchResult] = [] {
        didSet {
            Logger.shared.log("Received search results: \(results.map({ $0.id }))")
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient = TMDBAPIClient.shared
    
    init() {
        $query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.search()
            }
            .store(in: &cancellables)
    }
    
    func getNavigationDestination(for result: SearchResult) -> NavigationDestination {
        switch result.result {
        case .movie(let movie):
            return .media(.init(movie: movie))
        case .tv(let tVShow):
            return .media(.init(tvShow: tVShow))
        case .person(let person):
            return .person(.init(person: person))
        }
    }
    
    func search() {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            results = []
            return
        }
        apiClient.searchMulti(query: query)
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Search error:", error)
                }
            }, receiveValue: { [weak self] searchResults in
                self?.results = searchResults
            })
            .store(in: &cancellables)
    }
}

#Preview {
    SearchView()
}
