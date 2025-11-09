//
//  SeasonDetailsViewModel.swift
//  Movee
//
//  Created by user on 11/9/25.
//

import Foundation
import Combine

@Observable @MainActor
class SeasonDetailsViewModel: SectionFetchable, FailedSectionsReloadable {
    private let repo: SeasonDetailsDataRepositoryProtocol = SeasonDetailsDataRepository()
    
    private let tvShowID: Int
    var season: Season
    
    enum Section { case episodes }
    var fetchableSections: [Section] = [.episodes]
    var sectionsContext = AsyncLoadingContext<Section>()
    var maxConcurrentFetches: Int { 1 }

    @ObservationIgnored
    private lazy var fetchConfigs: [Section: AnyFetchConfig] = [
        .episodes: .init(.init(
            fetcher: { [tvShowID, season, repo] in
                try await repo.fetchSeason(tvShowID: tvShowID, seasonNumber: season.seasonNumber)
            },
            onSuccess: { [weak self] result in
                self?.season = result
            })
        )
    ]
    
    func fetchConfig(for section: Section) -> AnyFetchConfig? {
        fetchConfigs[section]
    }

    init(tvShowID: Int, season: Season) {
        self.tvShowID = tvShowID
        self.season = season
    }
}
