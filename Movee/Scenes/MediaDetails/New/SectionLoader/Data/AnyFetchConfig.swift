//
//  AnyFetchConfig.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

struct AnyFetchConfig {
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

    func fetch() async throws -> Bool {
        try await _fetch()
    }
}
