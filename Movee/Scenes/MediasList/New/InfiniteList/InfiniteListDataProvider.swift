//
//  InfiniteListDataProvider.swift
//  Movee
//
//  Created by user on 11/11/25.
//

protocol InfiniteListDataProvider {
    associatedtype Item: Identifiable

    var items: [Item] { get }
    var loadState: AsyncLoadingState { get }
    var hasMorePages: Bool { get }

    func fetch()
    func refresh()
}

extension PagedDataSource: @preconcurrency InfiniteListDataProvider { }
