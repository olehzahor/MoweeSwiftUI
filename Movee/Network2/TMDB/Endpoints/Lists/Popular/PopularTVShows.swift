//
//  PopularTVShows.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

extension TMDB {
    struct PopularTVShows: TMDBEndpoint {
        typealias Response = PaginatedResponse<TVShow>

        let page: Int

        var path: String {
            "tv/popular"
        }

        var method: HTTPMethod2 {
            .get
        }

        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
