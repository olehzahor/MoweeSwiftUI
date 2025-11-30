//
//  AiringTodayTVShows.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

// TODO: update other Endpoints to use lightweight parameters
// TODO: add compact logger by default, full for tests (even outside config with default compact!)

// TODO: complete network layer by configuring pure data requests (upload/download)
// TODO: ask AI for concrete Endpotin type (maybe it'd be just enoght for prev task)
// TODO: data body?
// TODO: ENCODER FOR REQUEST!! would solve data issue
// Unit tests for networking

extension TMDB {
    struct AiringTodayTVShows: TMDBEndpoint {
        typealias Response = PaginatedResponse<TVShow>

        let page: Int

        var path: String {
            "tv/airing_today"
        }

        var method: HTTPMethod {
            .get
        }

        var parameters: [String: Any]? {
            ["page": page]
        }
    }
}
