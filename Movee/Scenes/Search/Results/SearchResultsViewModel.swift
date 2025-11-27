//
//  SearchResultsViewModel.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Observation

@MainActor @Observable
final class SearchResultsViewModel {
    private let repo: SearchResultsRepositoryProtocol
    private(set) var query: String
    private(set) var scope: SearchScope

    private(set) var dataSource: PagedDataSource<SearchResult>

    @ObservationIgnored
    private var debounceTask: Task<Void, Never>?

    func update(query: String, scope: SearchScope) {
        debounceTask?.cancel()

        debounceTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }

            self.query = query
            self.scope = scope
            
            self.dataSource.cancelAll()
            self.dataSource = Self.createDataSource(repo, query: query, scope: scope)
            await self.dataSource.fetch()
        }
    }

    private static func createDataSource(_ repo: SearchResultsRepositoryProtocol, query: String, scope: SearchScope) -> PagedDataSource<SearchResult> {
        switch scope {
        case .all:
            return .pageNumber { [repo] page in
                try await repo.search(query, page: page)
            }
        case .movies:
            return .pageNumber { [repo] page in
                let response = try await repo.searchMovies(query, page: page)
                return response.map { SearchResult(.movie($0)) }
            }
        case .tvShows:
            return .pageNumber { [repo] page in
                let response = try await repo.searchTVShows(query, page: page)
                return response.map { SearchResult(.tv($0)) }
            }
        case .people:
            return .pageNumber { [repo] page in
                let response = try await repo.searchPersons(query, page: page)
                return response.map { SearchResult(.person($0)) }
            }
        }
    }

    init(query: String, scope: SearchScope, repo: SearchResultsRepositoryProtocol = SearchResultsRepository()) {
        self.query = query
        self.scope = scope
        self.repo = repo
        self.dataSource = Self.createDataSource(repo, query: query, scope: scope)
    }
}
