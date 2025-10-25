//
//  AnyFetchConfig.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

/// Type-erased wrapper for FetchConfig that allows storing heterogeneous configurations
/// in a collection (e.g., Dictionary) while maintaining type safety at the point of configuration
struct AnyFetchConfig {
    /// Priority for loading order (lower values load first)
    let priority: Int

    private let _fetch: () async throws -> Bool

    @MainActor
    init<Output>(_ config: FetchConfig<Output>) {
        self.priority = config.priority
        self._fetch = {
            let result = try await config.fetcher()
            config.onSuccess(result)
            return config.isEmpty(result)
        }
    }

    /// Executes the fetch operation
    /// - Returns: Whether the result is empty
    func fetch() async throws -> Bool {
        try await _fetch()
    }
}
