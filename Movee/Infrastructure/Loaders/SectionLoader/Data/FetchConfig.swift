//
//  FetchConfig.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

@MainActor
struct FetchConfig {
    let priority: Int
    
    private let _fetch: () async throws -> Bool
    
    func fetch() async throws -> Bool {
        try await _fetch()
    }
    
    init<Output>(
        priority: Int = .max,
        fetch: @escaping () async throws -> Output,
        update: @escaping (Output) -> Void,
        isEmpty: @escaping (Output) -> Bool = { _ in false }
    ) {
        self.priority = priority
        self._fetch = {
            let result = try await fetch()
            update(result)
            return isEmpty(result)
        }
    }
}
