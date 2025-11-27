//
//  Episode.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

struct Episode: Codable, Hashable, Identifiable {
    var id: Int
    var airDate: String?
    var episodeNumber: Int
    var episodeType: String?
    var name: String
    var overview: String
    var productionCode: String?
    var runtime: Int?
    var seasonNumber: Int
    var showID: Int?
    var stillPath: String?
    var voteAverage: Double?
    var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case airDate         = "air_date"
        case episodeNumber   = "episode_number"
        case episodeType     = "episode_type"
        case name
        case overview
        case productionCode  = "production_code"
        case runtime
        case seasonNumber    = "season_number"
        case showID          = "show_id"
        case stillPath       = "still_path"
        case voteAverage     = "vote_average"
        case voteCount       = "vote_count"
    }
}

extension Episode {
    var parsedAirDate: Date? {
        guard let airDate else { return nil }
        return MediaFormatterService.shared.parse(dateString: airDate)
    }

    var formattedAirDate: String? {
        MediaFormatterService.shared.format(date: parsedAirDate, style: .full)
    }

    var stillURL: URL? {
        TMDBImageURLProvider.shared.url(path: stillPath, size: .w342)
    }

    var durationString: String? {
        MediaFormatterService.shared.format(duration: runtime)
    }

    var detailsString: String? {
        [formattedAirDate, durationString].compactMap({ $0 }).joined(separator: " · ")
    }
}
