//
//  MediasListViewModel.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import Combine
import Foundation

@MainActor @Observable
final class MediasListViewModel {
    typealias OnDeleteClosure = (Media) -> Void

    let dataSource: any MediasInfiniteListDataProvider
    let title: String
    let largeTitle: Bool
    let emptyState: EmptyStateConfig
    let onDelete: OnDeleteClosure?

    init(_ dataSource: any MediasInfiniteListDataProvider, title: String, largeTitle: Bool, emptyState: EmptyStateConfig, onDelete: OnDeleteClosure? = nil) {
        self.dataSource = dataSource
        self.title = title
        self.largeTitle = largeTitle
        self.emptyState = emptyState
        self.onDelete = onDelete
    }
}

