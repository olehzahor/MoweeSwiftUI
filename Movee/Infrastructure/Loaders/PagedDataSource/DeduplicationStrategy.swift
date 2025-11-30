//
//  DeduplicationStrategy.swift
//  Movee
//
//  Created by user on 11/30/25.
//

import Foundation

protocol DeduplicationStrategy<Item> {
    associatedtype Item: Identifiable

    func deduplicate(_ newItems: [Item]) -> [Item]
    func reset()
}

final class SetBasedDeduplication<Item: Identifiable>: DeduplicationStrategy {
    private var itemIDs: Set<Item.ID> = []

    func deduplicate(_ newItems: [Item]) -> [Item] {
        let filtered = newItems.filter { !itemIDs.contains($0.id) }
        itemIDs.formUnion(filtered.map { $0.id })
        return filtered
    }

    func reset() {
        itemIDs.removeAll()
    }
}
