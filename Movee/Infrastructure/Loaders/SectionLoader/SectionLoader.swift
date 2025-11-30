//
//  SectionLoader.swift
//  Movee
//
//  Created by user on 11/12/25.
//

import Foundation

@MainActor @Observable
final class SectionLoader<Section: Hashable> {
    @ObservationIgnored
    private var configs: [Section: FetchConfig]
    let sections: [Section]
    let maxConcurrent: Int
    
    @ObservationIgnored
    private var currentTasks: [Section: Task<Void, Never>] = [:]

    private(set) var loadStates: [Section: LoadState] = [:]

    func setConfigs(_ configs: [Section: FetchConfig]) {
        self.configs = configs
    }
    
    func loadState(for section: Section) -> LoadState {
        loadStates[section] ?? .idle
    }

    func updateLoadState(for section: Section, _ state: LoadState) {
        loadStates[section] = state
    }

    func fetch(_ section: Section) async {
        guard let config = configs[section] else {
            let error = FetchError.noConfigurationFound(section: String(describing: section))
            loadStates[section] = .error(error)
            return
        }
        
        currentTasks[section]?.cancel()
        
        let previousState = loadStates[section]
        
        let task = Task {
            defer { currentTasks[section] = nil }
            
            loadStates[section] = .loading

            do {
                let isEmpty = try await config.fetch()
                try Task.checkCancellation()
                loadStates[section] = .loaded(isEmpty: isEmpty)
            } catch is CancellationError {
                loadStates[section] = previousState ?? .idle
            } catch {
                loadStates[section] = .error(error)
            }
        }

        currentTasks[section] = task
        
        await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }
    }

    private func fetchSections(_ sections: [Section]) async {
        let grouped = Dictionary(grouping: sections) { section in
            configs[section]?.priority ?? .max
        }

        for priority in grouped.keys.sorted() {
            let sectionsAtPriority = grouped[priority] ?? []

            for chunk in sectionsAtPriority.chunked(into: maxConcurrent) {
                await withTaskGroup { group in
                    for section in chunk {
                        group.addTask {
                            await self.fetch(section)
                        }
                    }
                }
            }
        }
    }
    
    func fetchInitialData() async {
        await fetchSections(sections)
    }
    
    func refetchFailed() async {
        let failedSections = sections.filter { loadStates[$0]?.error != nil }
        await fetchSections(failedSections)
    }
    
    func cancelAll() {
        for task in currentTasks.values {
            task.cancel()
        }
    }
    
    init(
        sections: [Section],
        configs: [Section: FetchConfig] = [:],
        maxConcurrent: Int = 3
    ) {
        self.sections = sections
        self.configs = configs
        self.maxConcurrent = maxConcurrent
    }
}

@MainActor
extension SectionLoader {
    var hasFailedSections: Bool {
        loadStates.values.contains { $0.error != nil }
    }

    var isLoadingAnySections: Bool {
        loadStates.values.contains { $0.isLoading }
    }

    var allSectionsLoaded: Bool {
        sections.allSatisfy { loadStates[$0]?.isLoaded ?? false }
    }
}
