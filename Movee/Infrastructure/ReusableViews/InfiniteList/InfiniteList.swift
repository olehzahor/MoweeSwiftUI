//
//  InfiniteList.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

// TODO: implement pull to refresh
struct InfiniteList<Item: Identifiable, Content: View, Placeholder: View, EmptyState: View>: View {
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content
    @ViewBuilder let placeholder: () -> Placeholder
    @ViewBuilder let emptyState: () -> EmptyState
    let placeholdersCount: Int
    let onFetchNextPage: () async -> Void
    let isEmpty: Bool
    let hasMorePages: Bool
    let threshold: Int
    let isSeparatorHidden: Bool
    let error: Error?
        
    @State private var retryTrigger = TaskTrigger()
    @State private var fetchedForCount: Int = -1

    private var separatorVisibility: Visibility {
        isSeparatorHidden ? .hidden : .visible
    }

    @ViewBuilder
    private var list: some View {
        List {
            if items.isEmpty, !isEmpty, error == nil {
                ForEach(Array(0..<placeholdersCount), id: \.self) { _ in
                    placeholder()
                        .listRowSeparator(separatorVisibility)
                }
            } else {
                ForEach(items) { item in
                    content(item)
                }
                .listRowSeparator(separatorVisibility)

                if hasMorePages {
                    placeholder()
                        .id(items.count)
                        .fallible()
                        .error(error) { retryTrigger.fire() }
                        .listRowSeparator(separatorVisibility)
                        .task { await onFetchNextPage() }
                }
            }
        }
        .onFire(retryTrigger) {
            await onFetchNextPage()
        }
        .onFirstAppear {
            await onFetchNextPage()
        }
    }
    
    var body: some View {
        if isEmpty, error == nil {
            emptyState()
        } else {
            list
        }
    }
    
    // MARK: - Initialization
    init(
        items: [Item],
        isEmpty: Bool = false,
        hasMorePages: Bool = true,
        threshold: Int = 3,
        placeholdersCount: Int = 5,
        isSeparatorHidden: Bool = true,
        error: Error?,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder = {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding()
        },
        @ViewBuilder emptyState: @escaping () -> EmptyState = {
            ContentUnavailableView(.search)
        },
        onFetchNextPage: @escaping () async -> Void
    ) {
        self.items = items
        self.content = content
        self.placeholder = placeholder
        self.emptyState = emptyState
        self.onFetchNextPage = onFetchNextPage
        self.isEmpty = isEmpty
        self.hasMorePages = hasMorePages
        self.threshold = threshold
        self.placeholdersCount = placeholdersCount
        self.isSeparatorHidden = isSeparatorHidden
        self.error = error
    }
}

// MARK: - Initialization with InfiniteListDataProvider
extension InfiniteList {
    init<DataProvider: InfiniteListDataProvider>(
        _ dataProvider: DataProvider,
        threshold: Int = 3,
        placeholdersCount: Int = 5,
        isSeparatorHidden: Bool = true,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder emptyState: @escaping () -> EmptyState
    ) where DataProvider.Item == Item {
            self.init(
                items: dataProvider.items,
                isEmpty: dataProvider.loadState.isEmpty,
                hasMorePages: dataProvider.hasMorePages,
                threshold: threshold,
                placeholdersCount: placeholdersCount,
                isSeparatorHidden: isSeparatorHidden,
                error: dataProvider.loadState.error,
                content: content,
                placeholder: placeholder,
                emptyState: emptyState,
                onFetchNextPage: dataProvider.fetch
            )
        }
}
