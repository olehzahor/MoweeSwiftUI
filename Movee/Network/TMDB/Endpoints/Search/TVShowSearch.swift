//
//  TVShowSearch.swift
//  Movee
//
//  Created by user on 11/20/25.
//

import Foundation

extension TMDB {
    struct TVShowSearch: TMDBEndpoint {
        typealias Response = PaginatedResponse<TVShow>

        let query: String
        let page: Int

        var path: String {
            "search/tv"
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
