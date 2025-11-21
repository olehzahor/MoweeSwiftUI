//
//  DiscoverRepository.swift
//  Movee
//
//  Created by user on 11/21/25.
//

import Factory

protocol DiscoverRepositoryProtocol {
    func discoverMovies(filters: DiscoverFilters, page: Int) async throws -> PaginatedResponse<Movie>
    func discoverTVShows(filters: DiscoverFilters, page: Int) async throws -> PaginatedResponse<TVShow>
}

struct DiscoverRepository: DiscoverRepositoryProtocol {
    private let network: NetworkClient

    func discoverMovies(filters: DiscoverFilters, page: Int) async throws -> PaginatedResponse<Movie> {
        try await network.request(TMDB.DiscoverMovies(page: page, filters: filters))
    }

    func discoverTVShows(filters: DiscoverFilters, page: Int) async throws -> PaginatedResponse<TVShow> {
        try await network.request(TMDB.DiscoverTVShows(page: page, filters: filters))
    }

    init(network: NetworkClient = Container.shared.networkClient()) {
        self.network = network
    }
}
