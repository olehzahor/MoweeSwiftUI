//
//  Media+TVShow.swift
//  Movee
//
//  Created by user on 4/9/25.
//

extension Media {
    init(tvShow: TVShow) {
        self.id = tvShow.id
        self.mediaType = .tvShow
        
        // For TV shows: display title and original title.
        self.title = tvShow.name
        self.originalTitle = tvShow.originalName
        self.tagline = tvShow.tagline
        self.overview = tvShow.overview
        self.posterPath = tvShow.posterPath
        self.backdropPath = tvShow.backdropPath
        self.popularity = tvShow.popularity
        self.voteAverage = tvShow.voteAverage
        self.voteCount = tvShow.voteCount
        
        // We use the first air date as the release date.
        self.releaseDate = tvShow.firstAirDate
        
        self.genreIDs = tvShow.genreIDs ?? []
        self.genres = tvShow.genres
        
        // Populate the extra info enum with all TV show details.
        self.extra = .tvShow(TVShowExtra(from: tvShow))
        self.subtitle = tvShow.character ?? tvShow.job
    }
}
