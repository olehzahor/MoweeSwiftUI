//
//  FetchConfig.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

/// Configuration for a fetchable section
/// - Output: The result type returned from the fetch operation
struct FetchConfig<Output> {
    /// Priority for loading order (lower values load first)
    let priority: Int

    /// The async operation that fetches data
    let fetcher: () async throws -> Output

    /// Callback to handle successful fetch result (typically updates published properties)
    let onSuccess: (Output) -> Void

    /// Determines if the fetched result is empty
    let isEmpty: (Output) -> Bool

    init(
        priority: Int = .max,
        fetcher: @escaping () async throws -> Output,
        onSuccess: @escaping (Output) -> Void,
        isEmpty: ((Output) -> Bool)? = Self.defaultIsEmpty
    ) {
        self.priority = priority
        self.fetcher = fetcher
        self.onSuccess = onSuccess
        self.isEmpty = isEmpty ?? Self.defaultIsEmpty
    }

    /// Smart default isEmpty check that detects Collection types at runtime
    private static var defaultIsEmpty: (Output) -> Bool {
        { output in
            // If Output conforms to Collection, check its isEmpty
            if let collection = output as? any Swift.Collection {
                return collection.isEmpty
            }
            // Otherwise, return false (non-empty)
            return false
        }
    }
}
