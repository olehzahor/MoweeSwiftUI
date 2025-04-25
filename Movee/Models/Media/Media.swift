//
//  Media.swift
//  Movee
//
//  Created by user on 4/9/25.
//

import Foundation

enum MediaType: String, Codable {
    case movie
    case tvShow
}

// MARK: - Top-Level Media Model
struct Media: Codable, Identifiable {
    let id: Int
    let mediaType: MediaType

    // Normalized common properties.
    let title: String                // Display title (movie.title or tvshow.name)
    let originalTitle: String        // movie.originalTitle or tvshow.originalName
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String?
    let genreIDs: [Int]
    let genres: [Genre]?
    
    // Type-specific extra info stored in an enum.
    let extra: ExtraInfo?
}

// MARK: - Extra Info Enum

extension Media {
    var posterURL: URL? {
        guard let posterPath else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w154"
        return URL(string: baseURL + posterPath)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        let baseURL = "https://image.tmdb.org/t/p/w780"
        return URL(string: baseURL + backdropPath)
    }
    
    var ratingString: String {
        MediaFormatterService.shared.format(rating: voteAverage)
    }
    
    var genreStrings: [String] {
        if let genres, !genres.isEmpty {
            return genres.map { $0.name }
        }
        return GenresMapper.shared.mapGenreIDs(genreIDs, for: mediaType)
    }
    
    var genresString: String {
        genreStrings.joined(separator: " · ")
    }
    
    var parsedReleaseDate: Date? {
        guard let releaseDate else { return nil }
        return MediaFormatterService.shared.parse(dateString: releaseDate)
    }
    
    var releaseYear: Int {
        guard let date = parsedReleaseDate else { return 1888 }
        return Calendar.current.component(.year, from: date)
    }
    
    var tagline: String? {
        switch extra {
        case .movie(let data):
            return data.tagline
        default:
            return nil
        }
    }
}
