//
//  Media.swift
//  Movee
//
//  Created by user on 4/9/25.
//

import Foundation

struct MediaIdentifier {
    let id: Int
    let type: MediaType
}

enum MediaType: String, Codable {
    case movie
    case tvShow = "tv"
}

// MARK: - Top-Level Media Model
struct Media: Codable, Identifiable {
    var id: Int
    let mediaType: MediaType

    // Normalized common properties.
    let title: String                // Display title (movie.title or tvshow.name)
    let originalTitle: String        // movie.originalTitle or tvshow.originalName
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
    
    // Type-specific extra info stored in an enum.
    var extra: ExtraInfo?
}

// MARK: - Extra Info Enum

extension Media {
    var posterURL: URL? {
        TMDBImageURLProvider.shared.url(path: posterPath, size: .w154)
    }
    
    var backdropURL: URL? {
        TMDBImageURLProvider.shared.url(path: backdropPath, size: .w780)
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
}
