//
//  GenresMapper.swift
//  Movee
//
//  Created by user on 4/9/25.
//

import Foundation

class GenresMapper {
    static let shared = GenresMapper()

    private let client = NetworkClient()

    // Fallback hardcoded values for movies
    private(set) var movieGenres: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]

    // Fallback hardcoded values for TV shows
    private(set) var tvGenres: [Int: String] = [
        10759: "Action & Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        10762: "Kids",
        9648: "Mystery",
        10763: "News",
        10764: "Reality",
        10765: "Sci-Fi & Fantasy",
        10766: "Soap",
        10767: "Talk",
        10768: "War & Politics"
    ]
    
    @MainActor
    private func downloadGenres() async {
        do {
            let response: GenresResponse = try await client.request(TMDB.MovieGenres())
            let mapping = Dictionary(uniqueKeysWithValues: response.genres.map { ($0.id, $0.name) })
            self.movieGenres = mapping
        } catch {
            print("Failed to download movie genres: \(error.localizedDescription). Using fallback values.")
        }

        do {
            let response: GenresResponse = try await client.request(TMDB.TVGenres())
            let mapping = Dictionary(uniqueKeysWithValues: response.genres.map { ($0.id, $0.name) })
            self.tvGenres = mapping
        } catch {
            print("Failed to download TV genres: \(error.localizedDescription). Using fallback values.")
        }
    }
    
    func mapping(for mediaType: MediaType) -> [Int: String] {
        switch mediaType {
        case .movie: return movieGenres
        case .tvShow: return tvGenres
        }
    }
    
    func mapGenreIDs(_ ids: [Int], for mediaType: MediaType) -> [String] {
        let mapping = self.mapping(for: mediaType)
        return ids.compactMap { mapping[$0] }
    }
    
    private init() {
        Task { await downloadGenres() }
    }
}

struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

struct GenresResponse: Codable {
    let genres: [Genre]
}
