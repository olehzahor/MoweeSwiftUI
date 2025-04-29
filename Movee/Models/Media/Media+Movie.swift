//
//  Media+Movie.swift
//  Movee
//
//  Created by user on 4/9/25.
//

extension Media {
    init(movie: Movie) {
        self.id = movie.id
        self.mediaType = .movie

        self.title = movie.title
        self.originalTitle = movie.originalTitle
        self.tagline = movie.tagline
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.backdropPath = movie.backdropPath
        self.popularity = movie.popularity
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.releaseDate = movie.releaseDate
        self.genreIDs = movie.genreIDs ?? []
        self.genres = movie.genres

        self.extra = .movie(MovieExtra(from: movie))
    }
}
