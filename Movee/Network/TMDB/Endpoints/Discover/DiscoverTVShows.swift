//
//  DiscoverTVShows.swift
//  Movee
//
//  Created by user on 11/21/25.
//

import Foundation

extension TMDB {
    struct DiscoverTVShows: TMDBEndpoint {
        typealias Response = PaginatedResponse<TVShow>

        let page: Int
        let filters: DiscoverFilters

        var path: String {
            "discover/tv"
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
