//
//  ExploreView.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import SwiftUI

struct ExploreView: View {
    @State private var viewModel: ExploreViewModel

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(viewModel.loader.sections) { section in
                    SectionView.medias(viewModel.medias[section], section: section)
                        .loadingState(viewModel.loader, section: section)
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Explore")
        .onFirstAppear {
            await viewModel.loader.fetchInitialData()
        }
    }
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
    }
    
    init(sections: [MediasSection]) {
        self.init(viewModel: ExploreViewModel(sections: sections))
    }
    
    init() {
        self.init(sections: .homePageSections)
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
