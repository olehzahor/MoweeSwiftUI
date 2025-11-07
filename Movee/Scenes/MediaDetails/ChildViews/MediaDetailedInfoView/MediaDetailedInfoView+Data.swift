//
//  Data.swift
//  Movee
//
//  Created by Oleh on 07.11.2025.
//

import Foundation

extension MediaDetailedInfoView {
    struct Data {
        let title: String
        let posterURL: URL?
        let releaseDate: String?
        let duration: String?
        let genres: String
        let mediaRating: Double?
        
        init(title: String, posterURL: URL? = nil, releaseDate: String? = nil, duration: String? = nil, genres: String, mediaRating: Double? = nil) {
            self.title = title
            self.posterURL = posterURL
            self.releaseDate = releaseDate
            self.duration = duration
            self.genres = genres
            self.mediaRating = mediaRating
        }
        
        init(media: Media) {
            title = media.title
            posterURL = media.posterURL
            releaseDate = media.releaseDateString
            duration = media.durationString
            genres = media.genresString
            mediaRating = media.voteAverage
        }
    }
}
