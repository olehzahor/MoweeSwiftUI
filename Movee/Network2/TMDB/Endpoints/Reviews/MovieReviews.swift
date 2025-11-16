//
//  MovieReviews.swift
//  Movee
//
//  Created by Oleh on 21.10.2025.
//

import Foundation

extension TMDB {
    struct MovieReviews: TMDBEndpoint {
        typealias Response = PaginatedResponse<Review>

        let movieID: Int
        let page: Int

        var path: String {
            "movie/\(movieID)/reviews"
        }

        var method: HTTPMethod2 {
            .get
        }
        
        var queryItems: [URLQueryItem]? {[
            URLQueryItem(name: "page", value: "\(page)")
        ]}
    }
}
