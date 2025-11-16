//
//  MovieRecommendations.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

import Foundation

extension TMDB {
    struct MovieRecommendations: TMDBEndpoint {
        typealias Response = PaginatedResponse<Movie>

        let movieID: Int
        let page: Int

        var path: String {
            "movie/\(movieID)/recommendations"
        }

        var method: HTTPMethod2 {
            .get
        }
        
        var queryItems: [URLQueryItem]? {[
            URLQueryItem(name: "page", value: "\(page)")
        ]}
    }
}
