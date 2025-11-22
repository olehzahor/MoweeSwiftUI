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

        currentTask?.cancel()

        let previousState = loadState

        let task = Task {
            defer { currentTask = nil }

            loadState = .loading

            do {
                if Bool.random() { throw NetworkError.invalidURL }
                try await Task.sleep(for: .seconds(5))
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
                print("CANCELED")
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
    }

    func refresh() async {
        currentTask?.cancel()
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
