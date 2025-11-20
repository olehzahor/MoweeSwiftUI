//
//  EmptyStateConfig.swift
//  Movee
//
//  Created by user on 11/18/25.
//

import SwiftUI

struct EmptyStateConfig {
    let title: String
    let systemImage: String
    let description: String
}

extension EmptyStateConfig {
    static var search = Self(
        title: "No results found",
        systemImage: "film.stack",
        description: "Try adjusting your search or filters"
    )

    static var watchlist = Self(
        title: "Your watchlist is empty",
        systemImage: "bookmark.slash",
        description: "Movies and TV Shows you add to your watchlist will appear here"
    )
}

extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    init(_ config: EmptyStateConfig) {
        self.init(
            config.title,
            systemImage: config.systemImage,
            description: Text(config.description)
        )
    }
}
