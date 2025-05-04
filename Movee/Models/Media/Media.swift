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
struct Media: Codable, Equatable, Identifiable {
    var id: Int
    var mediaType: MediaType

    // Normalized common properties.
    var title: String                // Display title (movie.title or tvshow.name)
    var originalTitle: String        // movie.originalTitle or tvshow.originalName
    var subtitle: String?
    var tagline: String?
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var popularity: Double
    var voteAverage: Double
    var voteCount: Int
    var releaseDate: String?
    var genreIDs: [Int]
    var genres: [Genre]?
    
    // Type-specific extra info stored in an enum.
    var extra: ExtraInfo?
    
    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
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
    
    var detailsString: String {
        [
          releaseYear.map(String.init),
          genresString.isEmpty ? nil : genresString
        ]
        .compactMap { $0 }
        .joined(separator: " · ")
    }
    
    var parsedReleaseDate: Date? {
        guard let releaseDate else { return nil }
        return MediaFormatterService.shared.parse(dateString: releaseDate)
    }
    
    var releaseYear: Int? {
        guard let date = parsedReleaseDate else { return nil }
        return Calendar.current.component(.year, from: date)
    }
    
    static var placeholder: Self {
        .init(id: -9000, mediaType: .movie, title: .placeholder(.short), originalTitle: .placeholder(.short), overview: .placeholder(.custom(200)), popularity: 0, voteAverage: 10.0, voteCount: 1, genreIDs: [28, 18])
    }
}
