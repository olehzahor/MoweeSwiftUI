//
//  MediasListView.swift
//  Movee
//
//  Created by user on 4/7/25.
//

import SwiftUI
import Combine

struct MediasListView: View {
    @StateObject var viewModel: MediasListViewModel

    private var medias: [Media] {
        if !viewModel.medias.isEmpty {
            return viewModel.medias
        } else {
            return Array(repeating: .placeholder, count: 10)
        }
    }
    
    private func setupRowView(_ media: Media) -> AnyView {
        var view: any View = MediaRowView(data: .init(media: media)).onAppear {
            if viewModel.isLastLoaded(media: media) {
                viewModel.fetchMedias()
            }
        }
        
        if media == .placeholder {
            view = view.redacted(reason: .placeholder).shimmering()
            return AnyView(view)
        } else {
            return AnyView(
                NavigationLink {
                    MediaDetailsView(media: media)
                } label: {
                    AnyView(view)
                }
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            List(Array(medias.enumerated()), id: \.0) { _, media in
                ZStack {
                    setupRowView(media)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            .onAppear {
                viewModel.fetchMedias()
            }
            .navigationTitle(viewModel.section.fullTitle ?? viewModel.section.title)
        }
    }
    
    init(section: MediasSection) {
        _viewModel = StateObject(wrappedValue: MediasListViewModel(section: section))
    }
}

#Preview {
    MediasListView(section: [MediasSection].homePageSections.first!)
}
