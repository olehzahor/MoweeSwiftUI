//
//  DiscoverMovies.swift
//  Movee
//
//  Created by user on 11/21/25.
//

import Foundation

extension TMDB {
    struct DiscoverMovies: TMDBEndpoint {
        typealias Response = PaginatedResponse<Movie>

        let page: Int
        let filters: DiscoverFilters

        var path: String {
            "discover/movie"
        }

        var method: HTTPMethod {
            .get
        }

        var parameters: [String: Any]? {
            var params = filters.toParameters()
            params["page"] = page
            return params
        }
    }
}
