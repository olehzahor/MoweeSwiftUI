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

    var body: some View {
        List(viewModel.medias) { media in
            NavigationLink {
                let mediaCopy = media
                MediaDetailsView(media: mediaCopy)
            } label: {
                MediaRowView(media: media)
                    .onAppear {
                        if media.id == viewModel.medias.last?.id {
                            viewModel.fetchMedias()
                        }
                    }
            }.listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.fetchMedias()
        }
        .navigationTitle(viewModel.section.fullTitle ?? viewModel.section.title)
    }
    
    init(section: MediasSection) {
        _viewModel = StateObject(wrappedValue: MediasListViewModel(section: section))
    }
}

#Preview {
    MediasListView(section: [MediasSection].homePageSections.first!)
}
