//
//  FetchConfig.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

protocol EmptyCheckable {
    var isEmpty: Bool { get }
}

extension Array: EmptyCheckable {}
extension Set: EmptyCheckable {}
extension Dictionary: EmptyCheckable {}
extension String: EmptyCheckable {}

struct FetchConfig<Output> {
    let priority: Int
    let fetcher: () async throws -> Output
    let onSuccess: (Output) -> Void
    let isEmpty: (Output) -> Bool

    init(
        priority: Int = .max,
        fetcher: @escaping () async throws -> Output,
        onSuccess: @escaping (Output) -> Void,
        isEmpty: @escaping (Output) -> Bool = { _ in false }
    ) {
        self.priority = priority
        self.fetcher = fetcher
        self.onSuccess = onSuccess
        self.isEmpty = isEmpty
    }
}

extension FetchConfig where Output: EmptyCheckable {
    init(
        priority: Int = .max,
        fetcher: @escaping () async throws -> Output,
        onSuccess: @escaping (Output) -> Void,
        isEmpty: @escaping (Output) -> Bool = {
            $0.isEmpty
        }
    ) {
        self.priority = priority
        self.fetcher = fetcher
        self.onSuccess = onSuccess
        self.isEmpty = isEmpty
    }
}
