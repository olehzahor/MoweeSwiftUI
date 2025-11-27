//
//  Data.swift
//  Movee
//
//  Created by user on 11/27/25.
//

import UIKit

extension MediaPosterView {
    struct Data {
        let posterURL: URL?
        let rating: Double?
        let title: String?
        let subtitle: String?
        let placeholder: UIImage?

        init(
            posterURL: URL?,
            rating: Double? = nil,
            title: String? = nil,
            subtitle: String? = nil,
            placeholder: UIImage? = nil
        ) {
            self.posterURL = posterURL
            self.rating = rating
            self.title = title
            self.subtitle = subtitle
            self.placeholder = placeholder
        }
    }
}

extension MediaPosterView.Data {
    init(media: Media) {
        self.posterURL = media.posterURL
        self.rating = media.voteAverage
        self.title = media.title
        self.subtitle = media.subtitle
        self.placeholder = media.placeholder
    }

    init(season: Season, media: Media?) {
        self.posterURL = season.posterURL ?? media?.posterURL
        self.rating = season.voteAverage
        self.title = season.name
        self.subtitle = season.subtitle
        self.placeholder = media?.placeholder ?? .imageMoviePlaceholder
    }
}
