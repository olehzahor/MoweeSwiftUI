//
//  Episode+Placeholder.swift
//  Movee
//
//  Created by user on 11/9/25.
//

extension Episode {
    static let placeholder = Episode(
        id: -1,
        episodeNumber: -1,
        name: .placeholder(.short),
        overview: .placeholder(.custom(100)),
        seasonNumber: 1,
        stillPath: nil)
}
