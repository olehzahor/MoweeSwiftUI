//
//  ExploreView.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import SwiftUI
import SwiftData
import Combine

struct ExploreView: View {
    private let viewModel = ExploreViewModel(sections: .homePageSections)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.fetchableSections) { section in
                        SectionView.medias(viewModel.medias[section], section: section)
                            .loading(viewModel.sectionsContext[section].isAwaitingData)
                            .error(viewModel.sectionsContext[section].error, retry: {
                                viewModel.reloadFailedSections()
                            })
//                            .loadingContext(viewModel.sectionsContext, section: section, reloader: viewModel)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Explore")
            .onFirstAppear {
                viewModel.fetchInitialData()
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
