//
//  MovieSearch.swift
//  Movee
//
//  Created by user on 11/20/25.
//

import Foundation

extension TMDB {
    struct MovieSearch: TMDBEndpoint {
        typealias Response = PaginatedResponse<Movie>

        let query: String
        let page: Int

        var path: String {
            "search/movie"
        }

        var method: HTTPMethod {
            .get
        }

        var parameters: [String: Any]? {[
            "query": query,
            "page": page
        ]}
    }
}
