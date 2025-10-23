//
//  TVShowCredits.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

import Foundation

extension TMDB {
    struct TVShowCredits: TMDBEndpoint {
        typealias Response = CreditsResponse

        let tvShowID: Int

        var path: String {
            "/tv/\(tvShowID)/credits"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
