//
//  NewPersonDetailsViewModel.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//

import Foundation

@Observable @MainActor
class NewPersonDetailsViewModel: SectionFetchable, FailedSectionsReloadable {
    private let repo: PersonDetailsRepositoryProtocol = PersonDetailsRepository()
    
    var person: MediaPerson
    var bio: String = ""
    var knownFor = SectionData<Media>(name: "Known for")
    
    enum Section: CaseIterable { case details, bio, knownFor }
    var fetchableSections: [Section] = Section.allCases
    var sectionsContext = AsyncLoadingContext<Section>()
    var maxConcurrentFetches: Int { 2 }
    
    @ObservationIgnored
    private(set) lazy var fetchConfigs: [Section: AnyFetchConfig] = [
        .details: AnyFetchConfig(
            FetchConfig(priority: 0) { [repo, person] in
                try await repo.fetchDetails(personID: person.id)
            } onSuccess: { [weak self] result in
                self?.person = result
            }
        ),
        .bio: AnyFetchConfig(
            FetchConfig { [unowned self] in
                person.biography ?? ""
            } onSuccess: { [weak self] result in
                self?.bio = result
            }
        ),
        .knownFor: AnyFetchConfig(
            FetchConfig { [repo, person] in
                try await repo.fetchKnownFor(personID: person.id)
            } onSuccess: { [weak self] result in
                self?.knownFor.items = Array(result.prefix(20))
                self?.knownFor.dataProvider = CustomMediasListDataProvider { _, _ in
                    .wrap(result)
                }
            }
        )
    ]
    
    func fetchConfig(for section: Section) -> AnyFetchConfig? {
        fetchConfigs[section]
    }
        
    init(person: MediaPerson) {
        self.person = person
    }
}
