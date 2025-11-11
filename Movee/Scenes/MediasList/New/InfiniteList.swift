//
//  InfiniteList.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

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
    
    private var separatorVisibility: Visibility {
        isSeparatorHidden ? .hidden : .visible
    }

    // MARK: - Body
    var body: some View {
        List {
            if items.isEmpty {
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
                        .listRowSeparator(separatorVisibility)
                }
            }
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
    }
}

extension InfiniteList {
    init<Fetcher: AutomaticPaginatedFetcher>(
        _ fetcher: Fetcher,
        threshold: Int = 3,
        placeholdersCount: Int = 5,
        isSeparatorHidden: Bool = true,
        @ViewBuilder content: @escaping (Item) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder)
    where Fetcher.Item == Item {
            self.init(
                items: fetcher.items,
                isLoading: fetcher.loadingState.isLoading,
                hasMorePages: fetcher.paginationContext.hasMorePages,
                threshold: threshold,
                placeholdersCount: placeholdersCount,
                isSeparatorHidden: isSeparatorHidden,
                content: content,
                placeholder: placeholder,
                onFetchNextPage: { fetcher.fetch() }
            )
        }
}
