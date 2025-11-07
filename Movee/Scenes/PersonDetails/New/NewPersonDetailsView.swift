//
//  NewPersonDetailsView.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//

import SwiftUI

struct NewPersonDetailsView: View {
    var viewModel: NewPersonDetailsViewModel
    @State private var isBioCollapsed = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImageView(
                    url: viewModel.person.largeProfilePictureURL,
                    width: 250,
                    height: 375,
                    cornerRadius: 8
                )
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical)
                
                SectionView(header: .init(title: "Biography")) {
                    FoldableTextView(text: viewModel.person.biography ?? "", lineLimit: 8)
                        .textStyle(.mediumText)
                }
                .loadable()
                .setLoading(viewModel.sectionsContext[.bio].isAwaitingData)
                //.loadingState(viewModel.sectionsContext[.bio], reloader: viewModel)
                
//                SectionView(header: .init(title: "Biography")) {
//                    FoldableTextView(text: "", lineLimit: 8)
//                        //.textStyle(.mediumText)
//                }
//                .loading(true)

                SectionView.medias(viewModel.knownFor.items,
                                   section: viewModel.knownFor.section)
                .loadingState(viewModel.sectionsContext[.knownFor], reloader: viewModel)
                                
                SectionView(header: .init(title: "Personal information")) {
                    MediaFactsView(facts: viewModel.person.facts)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onFirstAppear {
            viewModel.fetchInitialData()
        }
        .navigationTitle(viewModel.person.name)
    }

    init(person: MediaPerson) {
        viewModel = NewPersonDetailsViewModel(person: person)
    }
}
