//
//  CollectionViewModel.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

@MainActor @Observable
final class CollectionViewModel {
    private let repo: CollectionDataRepository

    private(set) var lists: [CollectionList] = []
    private(set) var title: String

    enum Section: CaseIterable { case main }
    let loader: SectionLoader<Section>

    @ObservationIgnored
    private lazy var fetchConfigs: [Section: FetchConfig] = [
        .main: .init(
            fetch: { [repo] in
                try await repo.fetchLists()
            },
            update: { [weak self] result in
                self?.lists = result
            }
        )
    ]

    init(title: String, repo: CollectionDataRepository) {
        self.title = title
        self.repo = repo

        self.loader = SectionLoader(sections: Section.allCases, maxConcurrent: 1)
        self.loader.setConfigs(fetchConfigs)
    }

    convenience init(title: String, lists: [CollectionList]) {
        self.init(title: title, repo: StaticCollectionDataRepository(lists: lists))
    }

    convenience init() {
        self.init(title: "Discover", repo: DiscoverCollectionDataRepository())
    }
}
