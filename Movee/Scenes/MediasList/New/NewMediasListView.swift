//
//  NewMediasListView.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import SwiftUI
import Combine


struct NewMediasListView: View {
    var viewModel: NewMediasListViewModel

    private var title: String {
        viewModel.section.fullTitle ?? viewModel.section.title
    }

    var body: some View {
        NavigationStack {
            InfiniteList(viewModel) { media in
                NavigationLink {
                    NewMediaDetailsView(media: media)
                } label: {
                    NewMediaRowView(data: .init(media: media))
                }
            } placeholder: {
                NewMediaRowView()
                    .loading(true)
            }
            .fallible()
            .error(viewModel.loadingState.error)
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onFirstAppear {
                viewModel.fetch()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(title == "Watchlist" ? .large : .inline)
        }
    }

    init(section: NewMediasSection) {
        viewModel = NewMediasListViewModel(section: section)
    }
}
