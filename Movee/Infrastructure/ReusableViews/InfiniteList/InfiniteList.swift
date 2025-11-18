//
//  InfiniteList.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

// TODO: implement pull to refresh
struct InfiniteList<Item: Identifiable, Content: View, Placeholder: View>: View {
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content
    @ViewBuilder let placeholder: () -> Placeholder
    let placeholdersCount: Int
    let onFetchNextPage: () -> Void
    let isLoading: Bool
    let hasMorePages: Bool
    let threshold: Int
    let isSeparatorHidden: Bool
    let error: Error?

    private var separatorVisibility: Visibility {
        isSeparatorHidden ? .hidden : .visible
    }

    // MARK: - Body
    var body: some View {
        List {
            if items.isEmpty, error == nil {
                ForEach(Array(0..<placeholdersCount), id: \.self) { _ in
                    placeholder()
                        .listRowSeparator(separatorVisibility)
                }
            } else {
                ForEach(items) { item in
                    content(item)
                        .listRowSeparator(separatorVisibility)
                        .onAppear {
                            handleItemAppear(item)
                        }
                }
                if hasMorePages {
                    placeholder()
                        .fallible()
                        .error(error, retry: onFetchNextPage)
                        .listRowSeparator(separatorVisibility)
                }
            }
        }
        .onFirstAppear {
            onFetchNextPage()
        }
    }

    // MARK: - Helpers
    private func handleItemAppear(_ item: Item) {
        guard hasMorePages, !isLoading else { return }
        guard let itemIndex = items.firstIndex(where: { $0.id == item.id }) else { return }

        let thresholdIndex = items.count - threshold

        if itemIndex >= thresholdIndex {
            onFetchNextPage()
        }
    }
    
    // MARK: - Initialization
    init(
        items: [Item],
        isLoading: Bool = false,
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
        onFetchNextPage: @escaping () -> Void
    ) {
        self.items = items
        self.content = content
        self.placeholder = placeholder
        self.onFetchNextPage = onFetchNextPage
        self.isLoading = isLoading
        self.hasMorePages = hasMorePages
        self.threshold = threshold
        self.placeholdersCount = placeholdersCount
        self.isSeparatorHidden = isSeparatorHidden
        self.error = error
    }
}

extension InfiniteList {
    init<DataProvider: InfiniteListDataProvider>(
        _ dataProvider: DataProvider,
        threshold: Int = 3,
        placeholdersCount: Int = 5,
        isSeparatorHidden: Bool = true,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder)
    where DataProvider.Item == Item {
            self.init(
                items: dataProvider.items,
                isLoading: dataProvider.loadState.isAwaitingData,
                hasMorePages: dataProvider.hasMorePages,
                threshold: threshold,
                placeholdersCount: placeholdersCount,
                isSeparatorHidden: isSeparatorHidden,
                error: dataProvider.loadState.error,
                content: content,
                placeholder: placeholder,
                onFetchNextPage: dataProvider.fetch
            )
        }
}
