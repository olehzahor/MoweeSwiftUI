//
//  MediasListView.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import SwiftUI

struct MediasListView: View {
    var viewModel: MediasListViewModel

    var body: some View {
        NavigationStack {            
            InfiniteList(viewModel.dataSource) { media in
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
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    init(section: MediasSection) {
        viewModel = MediasListViewModel(section: section)
    }
}
