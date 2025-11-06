//
//  PersonDetailsViewModel.swift
//  Movee
//
//  Created by user on 5/4/25.
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
                let combined = response.crew + response.cast
                var unique = [Media]()
                for credit in combined {
                    let media = credit.media
                    if let idx = unique.firstIndex(where: { $0.id == media.id }) {
                        var existing = unique[idx]
                        let existingText = existing.subtitle ?? ""
                        let newText = media.subtitle ?? ""
                        if !existingText.isEmpty && !newText.isEmpty {
                            existing.subtitle = existingText + " • " + newText
                        } else {
                            existing.subtitle = existingText.isEmpty ? newText : existingText
                        }
                        unique[idx] = existing
                    } else {
                        unique.append(media)
                    }
                }
                // Sort by popularity and wrap
                return .wrap(unique.sorted(by: { $0.voteCount >= $1.voteCount }))
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
            self.knownForMedias = Array(response.results.prefix(20))
        }.store(in: &cancellables)
    }
    
    init(person: MediaPerson) {
        self.person = person
    }
}
