//
//  PersonDetailsView.swift
//  Movee
//
//  Created by user on 4/17/25.
//

import SwiftUI
import Combine


struct PersonDetailsView: View {
    @StateObject var viewModel: PersonDetailsViewModel
    @State private var isBioCollapsed = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let profilePicture = viewModel.person.largeProfilePictureURL {
                    AsyncImageView(url: profilePicture, width: 250, height: 375, cornerRadius: 8)                    .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                
                VStack(alignment: .leading) {
                    if let biography = viewModel.person.biography, !biography.isEmpty {
                        Text("Biography")
                            .textStyle(.sectionTitle)
                        FoldableTextView(text: biography, lineLimit: 8)
                            .textStyle(.mediumText)
                    }
                }
                
                MediasSectionView(section: viewModel.knownFor, medias: viewModel.knownForMedias, errorMessage: nil, retry: {})
                
                VStack(alignment: .leading) {
                    Text("Personal information")
                        .textStyle(.sectionTitle)
                        .padding(.top)
                    MediaFactsView(facts: viewModel.person.facts)
                        .padding(.bottom)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .onFirstAppear {
            viewModel.fetchDetails()
        }
        .navigationTitle(viewModel.person.name)
    }

    init(person: MediaPerson) {
        _viewModel = StateObject(wrappedValue: PersonDetailsViewModel(person: person))
    }
}

#Preview {
    let mockPerson = MediaPerson(
        id: 117642,
        type: .cast,
        name: "John Doe",
        profilePath: "/sampleProfile1.jpg",
        role: "Director",
        creditID: "credit123",
        gender: 2,
        castID: nil,
        order: nil
    )
    PersonDetailsView(person: mockPerson)
}
