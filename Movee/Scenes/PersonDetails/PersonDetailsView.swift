//
//  PersonDetailsView.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//

import SwiftUI

struct PersonDetailsView: View {
    @State private var viewModel: PersonDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let pictureURL = viewModel.pictureURL {
                    AsyncImageView(url: pictureURL)
                        .frame(width: 250, height: 375)
                        .clipShape(.rect(cornerRadius: 12))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                
                SectionView(header: .init(title: "Biography")) {
                    FoldableTextView(text: viewModel.bio, lineLimit: 8)
                        .textStyle(.mediumText)
                }
                .loadingState(viewModel.loader, section: .bio)

                SectionView.medias(viewModel.knownFor.items,
                                   section: viewModel.knownFor.section)
                .loadingState(viewModel.loader, section: .knownFor)

                SectionView(header: .init(title: "Personal information")) {
                    MediaFactsView(facts: viewModel.person.facts)
                }
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onFirstAppear {
            await viewModel.loader.fetchInitialData()
        }
        .navigationTitle(viewModel.person.name)
    }

    init(person: MediaPerson) {
        viewModel = PersonDetailsViewModel(person: person)
    }
}

#Preview {
    PersonDetailsView(person: .mockWithoutMedia)
}
