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

// MARK: - Extra Info Enum
extension Media {
    var posterURL: URL? {
        TMDBImageURLProvider.shared.url(path: posterPath, size: .w154)
    }
    
    var backdropURL: URL? {
        TMDBImageURLProvider.shared.url(path: backdropPath, size: .w780)
    }
    
    var ratingString: String? {
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
    
    var releaseDateString: String? {
        switch mediaType {
        case .movie:
            guard let date = parsedReleaseDate else { return nil }
            return MediaFormatterService.shared.format(date: date)

        case .tvShow:
            // Year of first episode (releaseDate)
            guard let startDate = parsedReleaseDate else { return nil }
            let startYear = Calendar.current.component(.year, from: startDate)

            // Prepare status and end year
            var endYearString = ""
            var statusShort = ""

            if case let .tvShow(tvInfo) = extra {
                // Get short form from enum status directly
                statusShort = (tvInfo.status ?? .unknown).short

                // Determine the last possible air date: prefer next episode, fallback to last episode
                if let nextAir = tvInfo.nextEpisodeToAir?.airDate,
                   let nextDate = MediaFormatterService.shared.parse(dateString: nextAir) {
                    endYearString = String(Calendar.current.component(.year, from: nextDate))
                } else if let lastAir = tvInfo.lastEpisodeToAir?.airDate,
                          let lastDate = MediaFormatterService.shared.parse(dateString: lastAir) {
                    endYearString = String(Calendar.current.component(.year, from: lastDate))
                }
            }

            // Build the display string
            let yearRange = endYearString.isEmpty ? "\(startYear)" : "\(startYear)–\(endYearString)"
            if !statusShort.isEmpty {
                return "\(statusShort) (\(yearRange))"
            }
            return yearRange
        }
    }
    
    var duration: Int? {
        switch extra {
        case .movie(let movieExtra):
            return movieExtra.runtime
        case .tvShow(let tVShowExtra):
            // 1. Average runtime from episodeRunTime array if available
            if let runtimes = tVShowExtra.episodeRunTime, !runtimes.isEmpty {
                let total = runtimes.reduce(0, +)
                return Int(round(Double(total) / Double(runtimes.count)))
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    var durationString: String? {
        guard let duration, duration > 0 else { return nil }
        return MediaFormatterService.shared.format(duration: duration)
    }
    
    static var placeholder: Self {
        .init(id: -9000, mediaType: .movie, title: .placeholder(.short), originalTitle: .placeholder(.short), tagline: .placeholder(.short), overview: .placeholder(.custom(200)), popularity: 0, voteAverage: 0.0, voteCount: 0, genreIDs: [28, 18])
    }
    
    var seasons: [Season]? {
        guard let extra else { return nil }
        switch extra {
        case .movie:
            return nil
        case .tvShow(let data):
            return data.seasons
        }
    }
}
