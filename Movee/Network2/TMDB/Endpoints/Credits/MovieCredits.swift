//
//  MovieCredits.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

import Foundation

extension TMDB {
    struct MovieCredits: TMDBEndpoint {
        typealias Response = CreditsResponse

        let movieID: Int

        var path: String {
            "movie/\(movieID)/credits"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
