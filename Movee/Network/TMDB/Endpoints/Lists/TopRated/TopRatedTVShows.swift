//
//  TopRatedTVShows.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

extension TMDB {
    struct TopRatedTVShows: TMDBEndpoint {
        typealias Response = PaginatedResponse<TVShow>

        let page: Int

        var path: String {
            "tv/top_rated"
        }

        var method: HTTPMethod {
            .get
        }

        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
