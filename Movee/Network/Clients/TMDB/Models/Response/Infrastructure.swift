//
//  Infrastructure.swift
//  Movee
//
//  Created by user on 4/10/25.
//

// BelongsToCollection
struct BelongsToCollection: Codable {
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

// ProductionCompany
struct ProductionCompany: Codable, Identifiable {
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
struct ProductionCountry: Codable {
    let iso3166_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName: String?
    let iso639_1: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// Episode (for last/next episode details)
struct Episode: Codable {
    let id: Int
    let name: String
    let overview: String
    let voteAverage: Double?
    let voteCount: Int?
    // Add additional episode fields if needed
}

// Season (for TV show seasons)
struct Season: Codable, Identifiable {
    let id: Int
    let name: String
    let overview: String
    let episodeCount: Int
    let seasonNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case episodeCount = "episode_count"
        case seasonNumber = "season_number"
    }
}

// Network (for TV show networks)
struct Network: Codable, Identifiable {
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
struct CreditsResponse: Codable {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]
}

// CastMember: Represents an individual cast member.
struct CastMember: Codable, Identifiable {
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
struct CrewMember: Codable, Identifiable {
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
struct Person: Codable, Identifiable {
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
    
    enum CodingKeys: String, CodingKey {
        case id, name, birthday, deathday, biography, popularity, adult, homepage
        case department = "known_for_department"
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case alsoKnownAs = "also_known_as"
        case imdbID = "imdb_id"
    }
    
    init(id: Int, name: String, birthday: String? = nil, department: String? = nil, deathday: String? = nil, biography: String? = nil, popularity: Double? = nil, placeOfBirth: String? = nil, profilePath: String? = nil, adult: Bool? = nil, imdbID: String? = nil, homepage: String? = nil, alsoKnownAs: [String]? = nil) {
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
    }
}
