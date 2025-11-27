//
//  Media+StoredMedia.swift
//  Movee
//
//  Created by user on 11/27/25.
//

extension Media {
    init(_ stored: StoredMedia) {
        self.id = stored.id
        self.mediaType = stored.mediaType
        self.title = stored.title
        self.originalTitle = stored.originalTitle
        self.subtitle = stored.subtitle
        self.tagline = stored.tagline
        self.overview = stored.overview
        self.posterPath = stored.posterPath
        self.backdropPath = stored.backdropPath
        self.popularity = stored.popularity
        self.voteAverage = stored.voteAverage
        self.voteCount = stored.voteCount
        self.releaseDate = stored.releaseDate
        self.genreIDs = stored.genreIDs
        self.genres = stored.genres
        self.extra = nil
    }
}
