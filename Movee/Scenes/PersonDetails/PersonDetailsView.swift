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
    private var cancellables = Set<AnyCancellable>()

    func fetchDetails() {
        TMDBAPIClient.shared.fetchPersonDetails(personID: person.id).sink { completion in
            
        } receiveValue: { person in
            self.person = MediaPerson(person: person)
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
            VStack(alignment: .leading) {
                if let profilePicture = viewModel.person.profilePictureURL {
                    AsyncImageView(url: profilePicture, width: 250, height: 375, cornerRadius: 8)                    .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical)
                }
                if let biography = viewModel.person.biography, !biography.isEmpty {
                    Text("Biography").textStyle(.sectionTitle).textStyle(.smallText)
                    FoldableTextView(text: biography, lineLimit: 8)
                }
                Text("Personal information")
                    .textStyle(.sectionTitle)
                    .padding(.top)
                MediaFactsView(facts: viewModel.person.facts)
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .onAppear {
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
