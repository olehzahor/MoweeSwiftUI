//
//  WatchlistItem.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation
import SwiftData

/// Copy of ExtraInfo for Watchlist items
enum WatchlistExtraInfo: Codable {
    case movie(WatchlistMovieExtra)
    //case tvShow(WatchlistTVShowExtra)
}

struct WatchlistMovieExtra: Codable {
    let adult: Bool
    //let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let tagline: String?
    let homepage: String?
    let imdbID: String?
    let productionCompanies: [ProductionCompany]?
 let productionCountries: [ProductionCountry]?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let video: Bool

    init(from extra: MovieExtra) {
        self.adult = extra.adult
        //self.belongsToCollection = extra.belongsToCollection
        self.budget = extra.budget
        self.tagline = extra.tagline
        self.homepage = extra.homepage
        self.imdbID = extra.imdbID
        self.productionCompanies = extra.productionCompanies
        self.productionCountries = extra.productionCountries
        self.revenue = extra.revenue
        self.runtime = extra.runtime
        self.spokenLanguages = extra.spokenLanguages
        self.status = extra.status
        self.video = extra.video
    }
}

struct WatchlistTVShowExtra: Codable {
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
    let status: String?
    let type: String?

    init(from extra: TVShowExtra) {
        self.createdBy = extra.createdBy
        self.episodeRunTime = extra.episodeRunTime
        self.homepage = extra.homepage
        self.lastAirDate = extra.lastAirDate
        self.lastEpisodeToAir = extra.lastEpisodeToAir
        self.nextEpisodeToAir = extra.nextEpisodeToAir
        self.networks = extra.networks
        self.numberOfEpisodes = extra.numberOfEpisodes
        self.numberOfSeasons = extra.numberOfSeasons
        self.inProduction = extra.inProduction
        self.languages = extra.languages
        self.originCountry = extra.originCountry
        self.productionCompanies = extra.productionCompanies
        self.seasons = extra.seasons
        self.status = extra.status
        self.type = extra.type
    }
}

struct WatchlistMedia: Codable {
    let id: Int
    let mediaType: MediaType

    // Normalized common properties.
    let title: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String?
    let genreIDs: [Int]
    let extra: WatchlistExtraInfo?

    init(media: Media) {
        self.id = media.id
        self.mediaType = media.mediaType
        self.title = media.title
        self.originalTitle = media.originalTitle
        self.overview = media.overview
        self.posterPath = media.posterPath
        self.backdropPath = media.backdropPath
        self.popularity = media.popularity
        self.voteAverage = media.voteAverage
        self.voteCount = media.voteCount
        self.releaseDate = media.releaseDate
        self.genreIDs = media.genreIDs
        if let extra = media.extra {
            switch extra {
            case .movie(let movieExtra):
                self.extra = .movie(WatchlistMovieExtra(from: movieExtra))
            case .tvShow(let tvShowExtra):
                self.extra = nil
               // self.extra = .tvShow(WatchlistTVShowExtra(from: tvShowExtra))
            }
        } else {
            self.extra = nil
        }
    }
}

@Model
final class WatchlistItem: Sendable {
    var media: Media
    var added: Date
    
    init(media: Media) {
        self.media = media
        self.added = Date()
    }
}
