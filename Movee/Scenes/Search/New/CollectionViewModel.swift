//
//  CollectionViewModel.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

@MainActor @Observable
final class CollectionViewModel: SectionFetchable {
    private let repo: CollectionDataRepository
    
    private(set) var lists: [MediasList] = []
    private(set) var title: String
    
    enum Section { case main }
    var fetchableSections: [Section] = [.main]
    var sectionsContext = AsyncLoadingContext<Section>()
    var maxConcurrentFetches: Int { 1 }

    func fetchConfig(for section: Section) -> AnyFetchConfig? {
        .init(.init(fetcher: { [repo] in
            try await repo.fetchLists()
        }, onSuccess: { result in
            self.lists = result
        }))
    }
    
    
    init(title: String, repo: CollectionDataRepository) {
        self.title = title
        self.repo = repo
    }
    
    convenience init(title: String, lists: [MediasList]) {
        self.init(title: title, repo: StaticCollectionDataRepository(lists: lists))
    }

    convenience init() {
        self.init(title: "Discover", repo: DiscoverCollectionDataRepository())
    }
}
