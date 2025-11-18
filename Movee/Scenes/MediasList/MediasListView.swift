//
//  MediasListView.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import SwiftUI

struct MediasListView: View {
    @State private var viewModel: MediasListViewModel

    private var titleDisplayMode: NavigationBarItem.TitleDisplayMode {
        viewModel.largeTitle ? .large : .inline
    }
    
    private var emptyState: some View {
        ContentUnavailableView(
            viewModel.emptyState.title,
            systemImage: viewModel.emptyState.systemImage,
            description: Text(viewModel.emptyState.description)
        )
    }

    private var mediaList: some View {
        InfiniteList(viewModel.dataSource) { media in
            NavigationLink {
                MediaDetailsView(media: media)
            } label: {
                MediaRowView(data: .init(media: media))
            }
            .swipeActions(edge: .trailing) {
                if let onDelete = viewModel.onDelete {
                    Button(role: .destructive) {
                        onDelete(media)
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                }
            }
        } placeholder: {
            MediaRowView()
                .loading(true)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(titleDisplayMode)
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.dataSource.loadState.isEmpty {
                emptyState
            } else {
                mediaList
            }
        }
    }

    init(_ viewModel: MediasListViewModel) {
        self.viewModel = viewModel
    }
    
    init(section: MediasSection) {
        self.init(.section(section))
    }
}
