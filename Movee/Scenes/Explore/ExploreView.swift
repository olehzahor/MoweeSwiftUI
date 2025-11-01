//
//  ExploreView.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import SwiftUI
import SwiftData
import Combine

struct NewExploreView: View {
    private var viewModel = NewExploreViewModel(sections: .homePageSections)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.fetchableSections) { section in
                        SectionView.medias(viewModel.medias[section], section: section)
                            .loadingContext(viewModel.sectionsContext, section: section, retry: {})
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Explore")
            .onFirstAppear {
                viewModel.fetchInitialData()
            }
        }
    }
}

struct ExploreView: View {
    @StateObject private var viewModel = ExploreViewModel(sections: .homePageSections)
    
    var body: some View {
        NavigationStack {
            Group {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.sections) { section in
                            Group {
                                if viewModel.state.isEmpty(section) {
                                    EmptyView()
                                } else {
                                    MediasSectionView(
                                        section: section,
                                        medias: viewModel.medias[section],
                                        errorMessage: viewModel.state.getErrorMessage(section),
                                        retry: { viewModel.fetchMedias(section: section) }
                                    )
                                }
                            }.onFirstAppear {
                                viewModel.fetchMedias(section: section)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                        }
                    }
                }
            }
            .navigationTitle("Explore")
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        NewExploreView()
    }
}
