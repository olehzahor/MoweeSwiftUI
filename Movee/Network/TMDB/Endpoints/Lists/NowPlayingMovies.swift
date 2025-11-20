//
//  NowPlayingMovies.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

extension TMDB {
    struct NowPlayingMovies: TMDBEndpoint {
        typealias Response = PaginatedResponse<Movie>

        let page: Int

        var path: String {
            "movie/now_playing"
        }

        var method: HTTPMethod {
            .get
        }

        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
