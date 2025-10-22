//
//  Infrastructure.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

// Collection
struct Collection: Codable, Hashable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

extension Collection {
    var backdropURL: URL? {
        TMDBImageURLProvider.shared.url(path: backdropPath, size: .w780)
    }
}

// ProductionCompany
struct ProductionCompany: Codable, Hashable, Identifiable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

// ProductionCountry
struct ProductionCountry: Codable, Hashable {
    let iso3166_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// SpokenLanguage
struct SpokenLanguage: Codable, Hashable {
    let englishName: String?
    let iso639_1: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// Episode (full details)
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

// Season (for TV show seasons)
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

// Network (for TV show networks)
struct Network: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let logoPath: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

// CreditsResponse: Represents the full credits response from TMDB.
struct CreditsResponse: Codable, Hashable {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]
}

// CastMember: Represents an individual cast member.
struct CastMember: Codable, Hashable, Identifiable {
    let id: Int
    let castID: Int?
    let character: String?
    let creditID: String?
    let gender: Int?
    let name: String
    let order: Int?
    let profilePath: String?
    let department: String?
    let popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, name, order
        case profilePath = "profile_path"
        case department = "known_for_department"
        case popularity
    }
}

// CrewMember: Represents an individual crew member.
struct CrewMember: Codable, Hashable, Identifiable {
    let id: Int
    let creditID: String?
    let department: String?
    let gender: Int?
    let job: String?
    let name: String
    let profilePath: String?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case department, gender, job, name
        case profilePath = "profile_path"
        case popularity
    }
}

// Person (detailed TMDB person)
struct Person: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let birthday: String?
    let department: String?
    let deathday: String?
    let biography: String?
    let popularity: Double?
    let placeOfBirth: String?
    let profilePath: String?
    let adult: Bool?
    let imdbID: String?
    let homepage: String?
    let alsoKnownAs: [String]?
    let knownFor: [PersonCredit]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, birthday, deathday, biography, popularity, adult, homepage
        case department = "known_for_department"
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case alsoKnownAs = "also_known_as"
        case imdbID = "imdb_id"
        case knownFor = "known_for"
    }
    
    init(id: Int, name: String, birthday: String? = nil, department: String? = nil, deathday: String? = nil, biography: String? = nil, popularity: Double? = nil, placeOfBirth: String? = nil, profilePath: String? = nil, adult: Bool? = nil, imdbID: String? = nil, homepage: String? = nil, alsoKnownAs: [String]? = nil, knownFor: [PersonCredit]? = nil) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.department = department
        self.deathday = deathday
        self.biography = biography
        self.popularity = popularity
        self.placeOfBirth = placeOfBirth
        self.profilePath = profilePath
        self.adult = adult
        self.imdbID = imdbID
        self.homepage = homepage
        self.alsoKnownAs = alsoKnownAs
        self.knownFor = knownFor
    }
}
