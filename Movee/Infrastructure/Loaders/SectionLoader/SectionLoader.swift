//
//  SectionLoader.swift
//  Movee
//
//  Created by user on 11/12/25.
//

import Foundation

@MainActor
final class SectionLoader<Section: Hashable> {
    private var configs: [Section: FetchConfig2]
    let sections: [Section]
    let maxConcurrent: Int

    private var currentTasks: [Section: Task<Void, Never>] = [:]

    private(set) var loadStates: [Section: LoadState] = [:]

    init(
        sections: [Section],
        configs: [Section: FetchConfig2] = [:],
        maxConcurrent: Int = 3
    ) {
        self.sections = sections
        self.configs = configs
        self.maxConcurrent = maxConcurrent
    }

    func setConfigs(_ configs: [Section: FetchConfig2]) {
        self.configs = configs
    }
    
    func loadState(for section: Section) -> LoadState {
        loadStates[section] ?? .idle
    }

    func updateLoadState(for section: Section, _ state: LoadState) {
        loadStates[section] = state
    }

    func fetchInitialData() async {
        await fetchSections(sections)
    }

    func fetch(_ section: Section) async {
        currentTasks[section]?.cancel()

        guard let config = configs[section] else {
            let error = FetchError.noConfigurationFound(section: String(describing: section))
            loadStates[section] = .error(error)
            return
        }

        guard !loadState(for: section).isLoading else { return }
        let task = Task { @MainActor [weak self] in
            self?.loadStates[section] = .loading

            do {
                let isEmpty = try await config.fetch()
                guard !Task.isCancelled else { return }
                self?.loadStates[section] = .loaded(isEmpty: isEmpty)
            } catch {
                guard !Task.isCancelled else { return }
                self?.loadStates[section] = .error(error)
            }

            self?.currentTasks[section] = nil
        }

        currentTasks[section] = task
        
        await task.value
    }

    func refetchFailed() async {
        let failedSections = sections.filter { loadStates[$0]?.error != nil }
        await fetchSections(failedSections)
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
}

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
