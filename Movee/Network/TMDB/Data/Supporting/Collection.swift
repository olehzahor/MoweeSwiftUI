//
//  Collection.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

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
