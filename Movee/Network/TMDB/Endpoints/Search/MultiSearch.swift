//
//  MultiSearch.swift
//  Movee
//
//  Created by user on 11/20/25.
//

import Foundation

extension TMDB {
    struct MultiSearch: TMDBEndpoint {
        typealias Response = PaginatedResponse<SearchResult>

        let query: String
        let page: Int

        var path: String {
            "search/multi"
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
