//
//  TVShowRecommendations.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

import Foundation

extension TMDB {
    struct TVShowRecommendations: TMDBEndpoint {
        typealias Response = PaginatedResponse<TVShow>

        let tvShowID: Int
        let page: Int

        var path: String {
            "tv/\(tvShowID)/recommendations"
        }

        var method: HTTPMethod2 {
            .get
        }
        
        var queryItems: [URLQueryItem]? {[
            URLQueryItem(name: "page", value: "\(page)")
        ]}
    }
}
