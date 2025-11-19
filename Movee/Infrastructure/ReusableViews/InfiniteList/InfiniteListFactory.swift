//
//  InfiniteList+Factory.swift
//  Movee
//
//  Created by user on 11/17/25.
//

import SwiftUI

enum InfiniteListFactory {
    @ViewBuilder
    static func medias<DataProvider: InfiniteListDataProvider>(
        _ dataSource: DataProvider,
        onSelect: ((Media) -> Void)? = nil
    ) -> some View where DataProvider.Item == Media {
        InfiniteList(dataSource) { media in
            if let onSelect {
                Button {
                    onSelect(media)
                } label: {
                    MediaRowView(data: .init(media: media))
                }
            } else {
                MediasListRow(media: media)
            }
        } placeholder: {
            MediaRowView()
                .loading(true)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}

private struct MediasListRow: View {
    @Environment(\.coordinator) private var coordinator
    let media: Media

    var body: some View {
        Button {
            coordinator?.push(.mediaDetails(media))
        } label: {
            MediaRowView(data: .init(media: media))
        }
    }
}
