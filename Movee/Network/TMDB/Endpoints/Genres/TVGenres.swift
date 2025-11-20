//
//  TVGenres.swift
//  Movee
//
//  Created by user on 4/9/25.
//

import Foundation

extension TMDB {
    struct TVGenres: TMDBEndpoint {
        typealias Response = GenresResponse

        var path: String {
            "genre/tv/list"
        }

        var method: HTTPMethod {
            .get
        }
    }
}
