//
//  SectionFetchable+Fetch.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

extension SectionFetchable {
    /// Fire-and-forget fetch - starts the fetch but doesn't wait for completion
    @MainActor
    func fetch(_ section: SectionType) {
        guard let config = fetchConfigs[section] else {
            let error = FetchError.noConfigurationFound(section: String(describing: section))
            sectionsContext[section] = .error(error)
            return
        }

        guard !sectionsContext[section].isLoading else { return }

        let task = Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let isEmpty = try await config.fetch()
                guard !Task.isCancelled else { return }
                self.sectionsContext[section] = .loaded(isEmpty: isEmpty)
            } catch {
                self.sectionsContext[section] = .error(error)
            }
        }

        sectionsContext[section] = .loading(task: task)
    }

    /// Async fetch - waits for the fetch to complete before returning
    /// Useful for sequential fetches where one depends on another
    @MainActor
    func fetchAsync(_ section: SectionType) async {
        guard let config = fetchConfigs[section] else {
            let error = FetchError.noConfigurationFound(section: String(describing: section))
            sectionsContext[section] = .error(error)
            return
        }

        guard !sectionsContext[section].isLoading else { return }
        
        sectionsContext[section] = .loading(task: nil)
        do {
            let isEmpty = try await config.fetch()
            guard !Task.isCancelled else { return }
            self.sectionsContext[section] = .loaded(isEmpty: isEmpty)
        } catch {
            self.sectionsContext[section] = .error(error)
        }
    }
}
