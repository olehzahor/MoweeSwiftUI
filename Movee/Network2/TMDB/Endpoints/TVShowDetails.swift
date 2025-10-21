//
//  TVShowDetails.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

extension TMDB {
    struct TVShowDetails: TMDBEndpoint {
        typealias Response = TVShow

        let tvShowID: Int

        var path: String {
            "/tv/\(tvShowID)"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
