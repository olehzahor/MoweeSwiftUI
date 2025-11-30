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
    private let deduplicationStrategy: (any DeduplicationStrategy<Item>)?

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
                    items = deduplicationStrategy?.deduplicate(result.items) ?? result.items
                } else {
                    let newItems = deduplicationStrategy?.deduplicate(result.items) ?? result.items
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
        deduplicationStrategy?.reset()
        hasMorePages = true
        loadState = .idle
        onRefresh()
        await fetch()
    }

    func cancelAll() {
        currentTask?.cancel()
    }

    init(
        loadNext: @escaping () async throws -> PageLoadResult<Item>,
        onRefresh: @escaping () -> Void,
        deduplicationStrategy: (any DeduplicationStrategy<Item>)? = SetBasedDeduplication<Item>()
    ) {
        self.loadNext = loadNext
        self.onRefresh = onRefresh
        self.deduplicationStrategy = deduplicationStrategy
    }
}
