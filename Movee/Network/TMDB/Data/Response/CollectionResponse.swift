//
//  CollectionResponse.swift
//  Movee
//
//  Created by user on 5/4/25.
//


// MARK: - Collection Response
struct CollectionResponse: Decodable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let parts: [Movie]

    enum CodingKeys: String, CodingKey {
        case id, name, overview, parts
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
