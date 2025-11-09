//
//  Season.swift
//  Movee
//
//  Created by user on 11/9/25.
//

extension TMDB {
    struct TVShowSeason: TMDBEndpoint {
        typealias Response = Season

        let tvShowID: Int
        let seasonNumber: Int

        var path: String {
            "/tv/\(tvShowID)/season/\(seasonNumber)"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
