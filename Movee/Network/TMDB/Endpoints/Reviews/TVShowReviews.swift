//
//  TVShowReviews.swift
//  Movee
//
//  Created by Oleh on 21.10.2025.
//

import Foundation

extension TMDB {
    struct TVShowReviews: TMDBEndpoint {
        typealias Response = PaginatedResponse<Review>

        let tvShowID: Int
        let page: Int

        var path: String {
            "tv/\(tvShowID)/reviews"
        }

        var method: HTTPMethod {
            .get
        }
        
        var queryItems: [URLQueryItem]? {[
            URLQueryItem(name: "page", value: "\(page)")
        ]}
    }
}
