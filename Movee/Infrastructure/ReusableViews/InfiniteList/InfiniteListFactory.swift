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
        _ dataSource: DataProvider
    ) -> some View where DataProvider.Item == Media {
        InfiniteList(dataSource) { media in
            NavigationLink {
                MediaDetailsView(media: media)
            } label: {
                MediaRowView(data: .init(media: media))
            }
        } placeholder: {
            MediaRowView()
                .loading(true)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
    }
}
