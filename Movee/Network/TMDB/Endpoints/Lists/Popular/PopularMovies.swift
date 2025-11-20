//
//  PopularMovies.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

extension TMDB {
    struct PopularMovies: TMDBEndpoint {
        typealias Response = PaginatedResponse<Movie>

        let page: Int

        var path: String {
            "movie/popular"
        }

        var method: HTTPMethod {
            .get
        }

        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
