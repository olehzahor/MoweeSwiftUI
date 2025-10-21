//
//  MovieVideos.swift
//  Movee
//
//  Created by Oleh on 21.10.2025.
//

import Foundation

extension TMDB {
    struct MovieVideos: TMDBEndpoint {
        typealias Response = VideoResponse

        let movieID: Int

        var path: String {
            "/movie/\(movieID)/videos"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
