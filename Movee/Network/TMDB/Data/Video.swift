//
//  Video.swift
//  Movee
//
//  Created by user on 11/27/25.
//

import Foundation

struct Video: Decodable {
    let id: String
    let iso639_1: String?
    let iso3166_1: String?
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: VideoType
    let official: Bool?
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, key, name, site, size, type, official
        case iso639_1     = "iso_639_1"
        case iso3166_1    = "iso_3166_1"
        case publishedAt  = "published_at"
    }
}

/// TMDB video types (trailer, teaser, clip, etc.)
enum VideoType: String, Codable {
    case trailer         = "Trailer"
    case teaser          = "Teaser"
    case clip            = "Clip"
    case featurette      = "Featurette"
    case behindTheScenes = "Behind the Scenes"
    case bloopers        = "Bloopers"
    case openingCredits  = "Opening Credits"
    case recap           = "Recap"
    case intro           = "Intro"
    case unknown         = ""

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue  = try container.decode(String.self)
        self = VideoType(rawValue: rawValue) ?? .unknown
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

extension Video {
    var thumbnailURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return YouTubeURLProvider.shared.thumbnailURL(for: key, size: .hqDefault)
    }
}
