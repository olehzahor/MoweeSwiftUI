//
//  MovieGenres.swift
//  Movee
//
//  Created by user on 4/9/25.
//

import Foundation

extension TMDB {
    struct MovieGenres: TMDBEndpoint {
        typealias Response = GenresResponse

        var path: String {
            "genre/movie/list"
        }

        var method: HTTPMethod {
            .get
        }
    }
}
