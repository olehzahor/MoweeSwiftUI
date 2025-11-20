//
//  EmptyCheckable.swift
//  Movee
//
//  Created by user on 11/20/25.
//

protocol EmptyCheckable {
    var isEmpty: Bool { get }
}

extension Array: EmptyCheckable {}
extension Set: EmptyCheckable {}
extension Dictionary: EmptyCheckable {}
extension String: EmptyCheckable {}

extension FetchConfig {
    init<Output: EmptyCheckable>(
        priority: Int = .max,
        fetch: @escaping () async throws -> Output,
        update: @escaping (Output) -> Void
    ) {
        self.init(
            priority: priority,
            fetch: fetch, update:
                update, isEmpty: { $0.isEmpty }
        )
    }
}
