//
//  SeasonDetailsDataRepository.swift
//  Movee
//
//  Created by user on 11/9/25.
//

import Factory

protocol SeasonDetailsDataRepositoryProtocol {
    func fetchSeason(tvShowID: Int, seasonNumber: Int) async throws -> Season
}

struct SeasonDetailsDataRepository: SeasonDetailsDataRepositoryProtocol {
    private let network: NetworkClient
    
    func fetchSeason(tvShowID: Int, seasonNumber: Int) async throws -> Season {
        try await network.request(TMDB.TVShowSeason(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }
    
    init(network: NetworkClient = Container.shared.networkClient()) {
        self.network = network
    }
}
