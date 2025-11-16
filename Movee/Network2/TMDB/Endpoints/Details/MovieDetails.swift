//
//  MovieDetails.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

extension TMDB {
    struct MovieDetails: TMDBEndpoint {
        typealias Response = Movie

        let movieID: Int

        var path: String {
            "movie/\(movieID)"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
