//
//  UpcomingMovies.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

extension TMDB {
    struct UpcomingMovies: TMDBEndpoint {
        typealias Response = PaginatedResponse<Movie>

        let page: Int

        var path: String {
            "movie/upcoming"
        }

        var method: HTTPMethod2 {
            .get
        }

        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
