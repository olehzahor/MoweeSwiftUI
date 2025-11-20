//
//  SeasonDetailsViewModel.swift
//  Movee
//
//  Created by user on 11/9/25.
//

import Foundation
import Combine

@Observable @MainActor
final class SeasonDetailsViewModel {
    private let repo: SeasonDetailsDataRepositoryProtocol = SeasonDetailsDataRepository()

    private let tvShowID: Int
    var season: Season

    enum Section: CaseIterable { case episodes }
    let loader: SectionLoader<Section>

    @ObservationIgnored
    private lazy var fetchConfigs: [Section: FetchConfig2] = [
        .episodes: .init(
            fetch: { [tvShowID, season, repo] in
                try await repo.fetchSeason(tvShowID: tvShowID, seasonNumber: season.seasonNumber)
            },
            update: { [weak self] result in
                self?.season = result
            }
        )
    ]

    init(tvShowID: Int, season: Season) {
        self.tvShowID = tvShowID
        self.season = season

        self.loader = SectionLoader(sections: Section.allCases, maxConcurrent: 1)
        self.loader.setConfigs(fetchConfigs)
    }
}
