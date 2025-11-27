//
//  Season.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

struct Season: Codable, Hashable, Identifiable {
    let id: Int
    let airDate: String?
    let episodes: [Episode]?
    let episodeCount: Int?
    let name: String
    let overview: String
    let posterPath: String?
    let seasonNumber: Int
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case airDate       = "air_date"
        case episodes
        case episodeCount  = "episode_count"
        case name
        case overview
        case posterPath    = "poster_path"
        case seasonNumber  = "season_number"
        case voteAverage   = "vote_average"
    }
}

extension Season {
    var posterURL: URL? {
        TMDBImageURLProvider.shared.url(path: posterPath, size: .w780)
    }

    var parsedAirDate: Date? {
        guard let airDate else { return nil }
        return MediaFormatterService.shared.parse(dateString: airDate)
    }

    var subtitle: String {
        let yearString = parsedAirDate.map { String(Calendar.current.component(.year, from: $0)) }
        return [ "\(episodeCount ?? 0) eps", yearString ]
            .compactMap { $0 }
            .joined(separator: " · ")
    }
}
