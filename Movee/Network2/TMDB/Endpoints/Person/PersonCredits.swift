//
//  PersonCredits.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//

import Foundation

extension TMDB {
    struct PersonCredits: TMDBEndpoint {
        typealias Response = PersonCombinedCreditsResponse

        let personID: Int

        var path: String {
            "person/\(personID)/combined_credits"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
