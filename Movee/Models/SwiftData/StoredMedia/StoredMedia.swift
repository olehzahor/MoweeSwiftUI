//
//  StoredMedia.swift
//  Movee
//
//  Created by user on 5/5/25.
//


import Foundation
import SwiftData

struct StoredMedia: Codable {
    let id: Int
    let mediaType: MediaType
    let title: String
    let originalTitle: String
    let subtitle: String?
    let tagline: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String?
    let genreIDs: [Int]
    let genres: [Genre]?
    
    init(_ media: Media) {
        self.id = media.id
        self.mediaType = media.mediaType
        self.title = media.title
        self.originalTitle = media.originalTitle
        self.subtitle = media.subtitle
        self.tagline = media.tagline
        self.overview = media.overview
        self.posterPath = media.posterPath
        self.backdropPath = media.backdropPath
        self.popularity = media.popularity
        self.voteAverage = media.voteAverage
        self.voteCount = media.voteCount
        self.releaseDate = media.releaseDate
        self.genreIDs = media.genreIDs
        self.genres = media.genres
    }
}
