//
//  ExploreViewModel.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import Combine
import Foundation

@MainActor @Observable
final class ExploreViewModel: SectionFetchable, FailedSectionsReloadable {
    var fetchableSections: [NewMediasSection]

    var medias: [NewMediasSection: [Media]] = [:]
    
    var sectionsContext = AsyncLoadingContext<NewMediasSection>()
    var maxConcurrentFetches: Int { 2 }

    func fetchConfig(for section: NewMediasSection) -> AnyFetchConfig? {
        AnyFetchConfig(
            FetchConfig {
                try await section.dataProvider?.fetch(page: 1) ?? .wrap([])
            } onSuccess: { [weak self] response in
                self?.medias[section] = response.results
            } isEmpty: { response in
                response.results.isEmpty
            }
        )
    }
    
    init(sections: [NewMediasSection]) {
        fetchableSections = sections
    }
}
