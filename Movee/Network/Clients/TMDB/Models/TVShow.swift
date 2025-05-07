//
//  TVShow.swift
//  Movee
//
//  Created by user on 4/9/25.
//

struct TVShow: Codable, Identifiable {
    let id: Int
    let originalName: String
    let name: String
    let posterPath: String?
    let backdropPath: String?
    let createdBy: [Person]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let genreIDs: [Int]?
    let genres: [Genre]?
    let homepage: String?
    let inProduction: Bool?
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: Episode?
    let nextEpisodeToAir: Episode?
    let networks: [Network]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let originCountry: [String]?
    let originalLanguage: String?
    let overview: String
    let popularity: Double
    let productionCompanies: [ProductionCompany]?
    let seasons: [Season]?
    let status: SeriesStatus?
    let spokenLanguages: [SpokenLanguage]?
    let tagline: String?
    let type: String?
    let voteAverage: Double
    let voteCount: Int
    let character: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original_name"
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres
        case homepage
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case nextEpisodeToAir = "next_episode_to_air"
        case networks, numberOfEpisodes, numberOfSeasons, originCountry, originalLanguage, overview, popularity
        case productionCompanies = "production_companies"
        case seasons
        case status, type
        case spokenLanguages = "spoken_languages"
        case tagline
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIDs = "genre_ids"
        case character
        case job
    }
}
