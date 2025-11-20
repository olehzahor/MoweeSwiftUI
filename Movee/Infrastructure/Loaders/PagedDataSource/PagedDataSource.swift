//
//  PagedDataSource.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import Observation

// TODO: intergrate SectionLoader for fetches
@Observable
class PagedDataSource<Item: Identifiable&Decodable> {
    private let loadNext: () async throws -> PageLoadResult<Item>
    private let onRefresh: () -> Void
    
    private var currentTask: Task<Void, Never>?

    private(set) var items: [Item] = []
    private(set) var loadState = LoadState.idle
    private(set) var hasMorePages = true

    @MainActor
    func fetch() {
        guard hasMorePages, !loadState.isLoading else { return }
        
        currentTask?.cancel()
        
        loadState = .loading

        currentTask = Task { @MainActor in
            do {
                let result = try await loadNext()
                guard !Task.isCancelled else { return }

                if result.isFirstPage {
                    items = result.items
                } else {
                    items += result.items
                }

                hasMorePages = result.hasMore
                loadState = .loaded(isEmpty: result.items.isEmpty)
            } catch {
                guard !Task.isCancelled else { return }
                loadState = .error(error)
            }
        }
    }

    @MainActor
    func refresh() {
        currentTask?.cancel()
        items = []
        hasMorePages = true
        loadState = .idle
        onRefresh()
        fetch()
    }
    
    init(loadNext: @escaping () async throws -> PageLoadResult<Item>, onRefresh: @escaping () -> Void) {
        self.loadNext = loadNext
        self.onRefresh = onRefresh
    }

    deinit {
        currentTask?.cancel()
    }
}
