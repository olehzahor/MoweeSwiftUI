//
//  StoredItemsListDataProvider.swift
//  Movee
//
//  Created by user on 11/18/25.
//

final class StoredItemsListDataProvider<T: Identifiable>: InfiniteListDataProvider {
    var items: [T]
    
    var loadState: LoadState {
        .loaded(isEmpty: items.isEmpty)
    }
    
    var hasMorePages: Bool = false
    
    func fetch() { }
    
    func refresh() { }
    
    init(items: [T]) {
        self.items = items
    }
}
