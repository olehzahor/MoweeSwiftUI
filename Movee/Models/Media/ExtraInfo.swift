//
//  ExtraInfo.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation

enum ExtraInfo: Codable {
    case movie(MovieExtra)
    case tvShow(TVShowExtra)
}

// MARK: - Movie Extra Details
struct MovieExtra: Codable {
    let adult: Bool
    //let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let homepage: String?
    let imdbID: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let video: Bool
    
    init(from movie: Movie) {
        self.adult = movie.adult
        //self.belongsToCollection = movie.belongsToCollection
        self.budget = movie.budget
        self.homepage = movie.homepage
        self.imdbID = movie.imdbID
        self.productionCompanies = movie.productionCompanies
        self.productionCountries = movie.productionCountries
        self.revenue = movie.revenue
        self.runtime = movie.runtime
        self.spokenLanguages = movie.spokenLanguages
        self.status = movie.status
        self.video = movie.video
    }
}

// MARK: - TV Show Extra Details
struct TVShowExtra: Codable {
    let createdBy: [Person]?
    let episodeRunTime: [Int]?
    let homepage: String?
    let lastAirDate: String?
    let lastEpisodeToAir: Episode?
    let nextEpisodeToAir: Episode?
    let networks: [Network]?
    let numberOfEpisodes: Int?
    let numberOfSeasons: Int?
    let inProduction: Bool?
    let languages: [String]?
    let originCountry: [String]?
    let productionCompanies: [ProductionCompany]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let type: String?
    
    init(from tvShow: TVShow) {
        self.createdBy = tvShow.createdBy
        self.episodeRunTime = tvShow.episodeRunTime
        self.homepage = tvShow.homepage
        self.lastAirDate = tvShow.lastAirDate
        self.lastEpisodeToAir = tvShow.lastEpisodeToAir
        self.nextEpisodeToAir = tvShow.nextEpisodeToAir
        self.networks = tvShow.networks
        self.numberOfEpisodes = tvShow.numberOfEpisodes
        self.numberOfSeasons = tvShow.numberOfSeasons
        self.inProduction = tvShow.inProduction
        self.languages = tvShow.languages
        self.originCountry = tvShow.originCountry
        self.productionCompanies = tvShow.productionCompanies
        self.seasons = tvShow.seasons
        self.spokenLanguages = tvShow.spokenLanguages
        self.status = tvShow.status
        self.type = tvShow.type
    }
}
