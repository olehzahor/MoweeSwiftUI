//
//  Movie.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genreIDs: [Int]?
    let genres: [Genre]?
    let homepage: String?
    let imdbID: String?
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status: String?
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id, adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline
        case genreIDs = "genre_ids"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension Movie {
    static var mock: Movie {
        Movie(
            id: 950387,
            adult: false,
            backdropPath: "/2Nti3gYAX513wvhp8IiLL6ZDyOm.jpg",
            belongsToCollection: BelongsToCollection(
                id: 1461530,
                name: "The Minecraft Movie Collection",
                posterPath: nil,
                backdropPath: "/48TbIdb60bjLvVhj6W71YNvDM2p.jpg"
            ),
            budget: 150000000,
            genreIDs: [10751, 35, 12, 14],
            genres: [
                Genre(id: 10751, name: "Family"),
                Genre(id: 35, name: "Comedy"),
                Genre(id: 12, name: "Adventure"),
                Genre(id: 14, name: "Fantasy")
            ],
            homepage: "https://www.minecraft-movie.com",
            imdbID: "tt3566834",
            originalLanguage: "en",
            originalTitle: "A Minecraft Movie",
            overview: "Four misfits find themselves struggling with ordinary problems when they are suddenly pulled through a mysterious portal into the Overworld: a bizarre, cubic wonderland that thrives on imagination. To get back home, they'll have to master this world while embarking on a magical quest with an unexpected, expert crafter, Steve.",
            popularity: 990.9442,
            posterPath: "/yFHHfHcUgGAxziP1C3lLt0q2T4s.jpg",
            productionCompanies: [
                ProductionCompany(id: 174, logoPath: "/zhD3hhtKB5qyv7ZeL4uLpNxgMVU.png", name: "Warner Bros. Pictures", originCountry: "US"),
                ProductionCompany(id: 923, logoPath: "/5UQsZrfbfG2dYJbx8DxfoTr2Bvu.png", name: "Legendary Pictures", originCountry: "US"),
                ProductionCompany(id: 110691, logoPath: "/i0D9b0veZbValgEFiJjSd0mbb9C.png", name: "Mojang Studios", originCountry: "SE"),
                ProductionCompany(id: 829, logoPath: "/aXqwCvJSCDbTclkxAYfsT1l4Dsa.png", name: "Vertigo Entertainment", originCountry: "US"),
                ProductionCompany(id: 159602, logoPath: "/e3KodIPxOSC6xpzgIBISB4COQcu.png", name: "On the Roam", originCountry: "US"),
                ProductionCompany(id: 216687, logoPath: "/kKVYqekveOvLK1IgqdJojLjQvtu.png", name: "Domain Entertainment", originCountry: "US")
            ],
            productionCountries: [
                ProductionCountry(iso3166_1: "SE", name: "Sweden"),
                ProductionCountry(iso3166_1: "US", name: "United States of America")
            ],
            releaseDate: "2025-03-31",
            revenue: 323380122,
            runtime: 101,
            spokenLanguages: [
                SpokenLanguage(englishName: "English", iso639_1: "en", name: "English")
            ],
            status: "Released",
            tagline: "Be there and be square.",
            title: "The Minecraft Movie",
            video: false,
            voteAverage: 6.138,
            voteCount: 360
        )
    }
}
