//
//  TopRatedMovies.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

extension TMDB {
    struct TopRatedMovies: TMDBEndpoint {
        typealias Response = PaginatedResponse<Movie>

        let page: Int

        var path: String {
            "/movie/top_rated"
        }

        var method: HTTPMethod2 {
            .get
        }

        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
