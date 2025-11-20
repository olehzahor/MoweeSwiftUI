//
//  PersonSearch.swift
//  Movee
//
//  Created by user on 11/20/25.
//

import Foundation

extension TMDB {
    struct PersonSearch: TMDBEndpoint {
        typealias Response = PaginatedResponse<Person>

        let query: String
        let page: Int

        var path: String {
            "search/person"
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
