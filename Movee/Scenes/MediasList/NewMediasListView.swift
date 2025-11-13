//
//  NewMediasListView.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import SwiftUI

struct NewMediasListView: View {
    var viewModel: NewMediasListViewModel

    var body: some View {
        NavigationStack {
            InfiniteList(viewModel.dataSource) { media in
                NavigationLink {
                    MediaDetailsView(media: media)
                } label: {
                    NewMediaRowView(data: .init(media: media))
                }
            } placeholder: {
                NewMediaRowView()
                    .loading(true)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    init(section: NewMediasSection) {
        viewModel = NewMediasListViewModel(section: section)
    }
}
