//
//  PersonDetailsView.swift
//  Movee
//
//  Created by user on 4/17/25.
//

import SwiftUI
import Combine

class PersonDetailsViewModel: ObservableObject {
    @Published var person: MediaPerson
    @Published var knownForMedias: [Media]?
    
    lazy var knownFor = MediasSection(title: "Known for") { _ in
        TMDBAPIClient.shared.fetchPersonCredits(personID: self.person.id)
            .map { response in
                // Combine cast and crew, then filter unique by id
                let combined = response.cast + response.crew
                let unique = combined.reduce(into: [Media]()) { result, media in
                    if !result.contains(where: { $0.id == media.id }) {
                        result.append(media)
                    }
                }
                // Sort by popularity and wrap
                return .wrap(unique.sorted(by: { $0.popularity >= $1.popularity }))
            }
            .eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()

    func fetchDetails() {
        TMDBAPIClient.shared.fetchPersonDetails(personID: person.id).sink { completion in
            
        } receiveValue: { person in
            self.person = MediaPerson(person: person)
        }.store(in: &cancellables)
        
        knownFor.publisherBuilder?(1).sink { completion in
            
        } receiveValue: { response in
            self.knownForMedias = response.results
        }.store(in: &cancellables)
    }
    
    init(person: MediaPerson) {
        self.person = person
    }
}

struct PersonDetailsView: View {
    @StateObject var viewModel: PersonDetailsViewModel
    @State private var isBioCollapsed = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let profilePicture = viewModel.person.profilePictureURL {
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
