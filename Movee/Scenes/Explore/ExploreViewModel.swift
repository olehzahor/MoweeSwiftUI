//
//  ExploreViewModel.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import Combine
import Foundation

@MainActor @Observable
final class ExploreViewModel {
    let loader: SectionLoader<MediasSection>
    var medias: [MediasSection: [Media]] = [:]
    
    init(sections: [MediasSection]) {
        loader = SectionLoader(sections: sections, maxConcurrent: 2)

        let configs = Dictionary(uniqueKeysWithValues: sections.map { section in
            (section, FetchConfig {
                return try await section.dataProvider?.fetch(page: 1) ?? .wrap([])
            } update: { [weak self] response in
                self?.medias[section] = response.results
            } isEmpty: { response in
                response.results.isEmpty
            })
        })
        loader.setConfigs(configs)
    }
}
