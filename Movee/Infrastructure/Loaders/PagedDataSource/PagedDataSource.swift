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
    private(set) var loadState = LoadState.idle
    private(set) var hasMorePages = true

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
                    items += result.items
                }

                hasMorePages = result.hasMore
                loadState = .loaded(isEmpty: result.items.isEmpty)
            } catch is CancellationError {
                loadState = previousState
            } catch {
                loadState = .error(error)
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
