//
//  Media.swift
//  Movee
//
//  Created by user on 4/9/25.
//

import Foundation
import UIKit

struct MediaIdentifier {
    let id: Int
    let type: MediaType
}

enum MediaType: String, Codable {
    case movie
    case tvShow = "tv"
}

// MARK: - Top-Level Media Model
struct Media: Hashable, Codable, Equatable, Identifiable {
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

extension Media {
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case title
        case originalTitle = "original_title"
        case subtitle
        case tagline
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
        case genres
        case extra
    }
}
