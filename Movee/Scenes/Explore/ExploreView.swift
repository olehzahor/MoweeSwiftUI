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
    @StateObject private var viewModel = ExploreViewModel(sections: .homePageSections)
    
    var body: some View {
        NavigationView {
            Group {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(viewModel.sections) { section in
                            MediasSectionView(
                                section: section,
                                medias: viewModel.medias[section],
                                errorMessage: viewModel.errors[section]?.localizedDescription,
                                isLoading: viewModel.isLoading[section] ?? false,
                                retry: { viewModel.fetchMedias(section: section) }
                            ).onFirstAppear {
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
        ExploreView()
    }
}
