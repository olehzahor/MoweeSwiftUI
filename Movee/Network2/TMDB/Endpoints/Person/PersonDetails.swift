//
//  PersonDetails.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//

import Foundation

extension TMDB {
    struct PersonDetails: TMDBEndpoint {
        typealias Response = Person

        let personID: Int

        var path: String {
            "person/\(personID)"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
