//
//  SearchResultsRepository.swift
//  Movee
//
//  Created by user on 11/20/25.
//

import Factory

protocol SearchResultsRepositoryProtocol {
    func search(_ query: String, page: Int) async throws -> PaginatedResponse<SearchResult>
    func searchMovies(_ query: String, page: Int) async throws -> PaginatedResponse<Movie>
    func searchTVShows(_ query: String, page: Int) async throws -> PaginatedResponse<TVShow>
    func searchPersons(_ query: String, page: Int) async throws -> PaginatedResponse<Person>
}

struct SearchResultsRepository: SearchResultsRepositoryProtocol {
    private let network: NetworkClient

    func search(_ query: String, page: Int) async throws -> PaginatedResponse<SearchResult> {
        try await network.request(TMDB.MultiSearch(query: query, page: page))
    }

    func searchMovies(_ query: String, page: Int) async throws -> PaginatedResponse<Movie> {
        try await network.request(TMDB.MovieSearch(query: query, page: page))
    }

    func searchTVShows(_ query: String, page: Int) async throws -> PaginatedResponse<TVShow> {
        try await network.request(TMDB.TVShowSearch(query: query, page: page))
    }

    func searchPersons(_ query: String, page: Int) async throws -> PaginatedResponse<Person> {
        try await network.request(TMDB.PersonSearch(query: query, page: page))
    }

    init(network: NetworkClient = Container.shared.networkClient()) {
        self.network = network
    }
}
