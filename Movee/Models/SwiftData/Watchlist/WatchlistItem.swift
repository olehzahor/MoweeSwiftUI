//
//  WatchlistItem.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation
import SwiftData

struct WatchlistMedia: Codable {
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

@Model
final class WatchlistItem: Sendable {
    var media: WatchlistMedia
    var added: Date
    
    init(media: WatchlistMedia) {
        self.media = media
        self.added = Date()
    }
}

extension Media {
    init(_ watchlist: WatchlistMedia) {
        self.id = watchlist.id
        self.mediaType = watchlist.mediaType
        self.title = watchlist.title
        self.originalTitle = watchlist.originalTitle
        self.subtitle = watchlist.subtitle
        self.tagline = watchlist.tagline
        self.overview = watchlist.overview
        self.posterPath = watchlist.posterPath
        self.backdropPath = watchlist.backdropPath
        self.popularity = watchlist.popularity
        self.voteAverage = watchlist.voteAverage
        self.voteCount = watchlist.voteCount
        self.releaseDate = watchlist.releaseDate
        self.genreIDs = watchlist.genreIDs
        self.genres = watchlist.genres
        self.extra = nil
    }
}
