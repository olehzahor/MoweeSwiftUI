//
//  Data.swift
//  Movee
//
//  Created by Oleh on 07.11.2025.
//

import Foundation
import UIKit

extension MediaDetailedInfoView {
    struct Data {
        let title: String
        let posterURL: URL?
        let releaseDate: String?
        let duration: String?
        let genres: String
        let mediaRating: Double?
        let placeholder: UIImage?
    }
}

extension MediaDetailedInfoView.Data {
    var posterData: MediaPosterView.Data {
        .init(
            posterURL: posterURL,
            rating: mediaRating,
            placeholder: placeholder
        )
    }
}

extension MediaDetailedInfoView.Data {
    init(media: Media) {
        title = media.title
        posterURL = media.posterURL
        releaseDate = media.releaseDateString
        duration = media.durationString
        genres = media.genresString
        mediaRating = media.voteAverage
        placeholder = media.placeholder
    }
}
