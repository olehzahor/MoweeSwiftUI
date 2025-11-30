//
//  PagedDataSource.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import Observation

@MainActor @Observable
class PagedDataSource<Item: Identifiable&Decodable> {
    private let loadNext: () async throws -> PageLoadResult<Item>
    private let onRefresh: () -> Void
    
    @ObservationIgnored
    private var currentTask: Task<Void, Never>?
    
    private(set) var items: [Item] = []
    @ObservationIgnored
    private(set) var loadState = LoadState.idle
    private(set) var hasMorePages = true
    
    var isEmpty: Bool { loadState.isEmpty }
    var error: Error? { loadState.error }

    func fetch() async {
        guard hasMorePages, !loadState.isLoading else { return }

        let previousState = loadState
        loadState = .loading

        let task = Task {
            do {
                let result = try await loadNext()
                try Task.checkCancellation()

                if result.isFirstPage {
                    items = result.items
                } else {
                    // Deduplicate: only append items not already in array
                    let existingIDs = Set(items.map { $0.id })
                    let newItems = result.items.filter { !existingIDs.contains($0.id) }
                    items += newItems
                }

                hasMorePages = result.hasMore
                loadState = .loaded(isEmpty: result.items.isEmpty)
            } catch {
                if Task.isCancelled {
                    loadState = previousState
                } else {
                    loadState = .error(error)
                }
            }
        }
        
        currentTask = task
        await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }
        currentTask = nil
    }

    func refresh() async {
        currentTask?.cancel()
        await currentTask?.value
        items = []
        hasMorePages = true
        loadState = .idle
        onRefresh()
        await fetch()
    }

    func cancelAll() {
        currentTask?.cancel()
    }

    init(loadNext: @escaping () async throws -> PageLoadResult<Item>, onRefresh: @escaping () -> Void) {
        self.loadNext = loadNext
        self.onRefresh = onRefresh
    }
}
