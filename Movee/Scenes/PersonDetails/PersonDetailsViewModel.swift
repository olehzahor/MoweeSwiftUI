//
//  PersonDetailsViewModel.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//

import Foundation

@Observable @MainActor
final class PersonDetailsViewModel {
    private let repo: PersonDetailsRepositoryProtocol = PersonDetailsRepository()

    var person: MediaPerson
    var bio: String = ""
    var knownFor = SectionData<Media>(name: "Known for")

    enum Section: CaseIterable { case details, bio, knownFor }
    let loader: SectionLoader<Section>

    @ObservationIgnored
    private lazy var fetchConfigs: [Section: FetchConfig] = [
        .details: .init(
            priority: 0,
            fetch: { [repo, person] in
                try await repo.fetchDetails(personID: person.id)
            },
            update: { [weak self] result in
                self?.person = result
            }
        ),
        .bio: .init(
            fetch: { [weak self] in
                self?.person.biography ?? ""
            },
            update: { [weak self] result in
                self?.bio = result
            }
        ),
        .knownFor: .init(
            fetch: { [repo, person] in
                try await repo.fetchKnownFor(personID: person.id)
            },
            update: { [weak self] result in
                self?.knownFor.items = Array(result.prefix(20))
                self?.knownFor.dataProvider = CustomMediasListDataProvider { _ in
                    .wrap(result)
                }
            }
        )
    ]

    init(person: MediaPerson) {
        self.person = person

        self.loader = SectionLoader(sections: Section.allCases, maxConcurrent: 2)
        self.loader.setConfigs(fetchConfigs)
    }
}
