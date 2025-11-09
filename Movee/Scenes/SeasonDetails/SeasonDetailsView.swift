//
//  SeasonDetailsView.swift
//  Movee
//
//  Created by user on 4/30/25.
//

import SwiftUI
import Combine

struct SeasonDetailsView: View {
    @State var viewModel: SeasonDetailsViewModel

    var body: some View {
        List {
            Section {
                if !viewModel.season.overview.isEmpty {
                    FoldableTextView(text: viewModel.season.overview, lineLimit: 10)
                        .textStyle(.mediumText)
                        .listSeparatorTrailingAligned()
                        .listRowSeparator(.hidden, edges: .top)
                }
                
                EpisodesListView(episodes: viewModel.season.episodes)
                    .loadingState(viewModel, section: .episodes)
            }.listSectionSeparator(.hidden)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .navigationTitle(viewModel.season.name)
        .onFirstAppear {
            viewModel.fetchInitialData()
        }
    }
    
    init(_ viewModel: SeasonDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    init(tvShowID: Int, season: Season) {
        self.init(SeasonDetailsViewModel(tvShowID: tvShowID, season: season))
    }
}

#Preview {
    SeasonDetailsView(tvShowID: 100088, season: .mock)
}
