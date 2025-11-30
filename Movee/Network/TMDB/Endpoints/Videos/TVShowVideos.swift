//
//  TVShowVideos.swift
//  Movee
//
//  Created by Oleh on 21.10.2025.
//

import Foundation

extension TMDB {
    struct TVShowVideos: TMDBEndpoint {
        typealias Response = VideoResponse

        let tvShowID: Int

        var path: String {
            "tv/\(tvShowID)/videos"
        }

        var method: HTTPMethod {
            .get
        }
    }
}
