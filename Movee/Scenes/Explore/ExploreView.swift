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
    @State private var viewModel: ExploreViewModel = ExploreViewModel(sections: .homePageSections)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.fetchableSections) { section in
                        SectionView.medias(viewModel.medias[section], section: section)
                            .loadingState(viewModel, section: section)
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
