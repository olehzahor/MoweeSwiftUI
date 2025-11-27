//
//  PersonCombinedCreditsResponse.swift
//  Movee
//
//  Created by user on 4/29/25.
//

enum PersonCredit: Codable, Hashable {
    case movie(Movie)
    case tvShow(TVShow)

    private enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(MediaType.self, forKey: .mediaType)
        switch type {
        case .movie:
            let movie = try Movie(from: decoder)
            self = .movie(movie)
        case .tvShow:
            let show = try TVShow(from: decoder)
            self = .tvShow(show)
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .movie(let movie):
            try movie.encode(to: encoder)
        case .tvShow(let show):
            try show.encode(to: encoder)
        }
    }
    
    var media: Media {
        switch self {
        case .movie(let movie):
            Media(movie: movie)
        case .tvShow(let tVShow):
            Media(tvShow: tVShow)
        }
    }
}

struct PersonCombinedCreditsResponse: Codable, Hashable {
    let cast: [PersonCredit]
    let crew: [PersonCredit]
}
