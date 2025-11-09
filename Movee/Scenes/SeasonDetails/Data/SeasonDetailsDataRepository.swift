//
//  SeasonDetailsDataRepository.swift
//  Movee
//
//  Created by user on 11/9/25.
//

protocol SeasonDetailsDataRepositoryProtocol {
    func fetchSeason(tvShowID: Int, seasonNumber: Int) async throws -> Season
}

struct SeasonDetailsDataRepository: SeasonDetailsDataRepositoryProtocol {
    private let network: NetworkClient2 = Dependencies.networkClient
    
    func fetchSeason(tvShowID: Int, seasonNumber: Int) async throws -> Season {
        try await Task.sleep(for: .seconds(5))
        return try await network.request(TMDB.TVShowSeason(tvShowID: tvShowID, seasonNumber: seasonNumber))
    }
}
