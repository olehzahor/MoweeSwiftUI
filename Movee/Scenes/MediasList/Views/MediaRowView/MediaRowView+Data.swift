//
//  MediaRowView+Data.swift
//  Movee
//
//  Created by user on 11/26/25.
//

import UIKit

extension MediaRowView {
    struct Data: Identifiable {
        let id: Int
        let title: String?
        let details: String?
        let overview: String?
        let posterURL: URL?
        let rating: Double?
        let placeholder: UIImage?
    }
}

extension MediaRowView.Data {
    static let placeholder = Self(
        id: 0,
        title: "############",
        details: "#### · ######",
        overview: String.placeholder(.long),
        posterURL: nil,
        rating: 0,
        placeholder: .imageMoviePlaceholder
    )
    
    var posterData: MediaPosterView.Data {
        .init(
            posterURL: posterURL,
            rating: rating,
            placeholder: placeholder
        )
    }
}

extension MediaRowView.Data {
    init(media: Media) {
        self.id = media.id
        self.title = media.title
        self.details = media.subtitle
        self.overview = media.overview
        self.posterURL = media.posterURL
        self.rating = media.voteAverage
        self.placeholder = media.placeholder
    }
}
