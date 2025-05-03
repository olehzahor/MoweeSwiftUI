//
//  NavigationAction.swift
//  Movee
//
//  Created by user on 4/30/25.
//

import Foundation
import UIKit

extension MediaPosterView {
    struct DataModel: Identifiable {
        enum Object {
            case media(Media)
            // TODO: store media fully
            case season(Season, tvShowID: Int?)
        }

        var id: Int = -1
        var title: String?
        var subtitle: String?
        var posterURL: URL?
        var posterPlaceholder: UIImage?
        var rating: Double?
        var object: Object?
    }
}

extension MediaPosterView.DataModel {
    static var placeholder = Self(title: .placeholder(.short))
    
    init(media: Media) {
        self.id = media.id
        self.title = media.title
        self.subtitle = media.subtitle
        self.posterURL = media.posterURL
        self.rating = media.voteAverage
        self.object = .media(media)
    }
    
    init(season: Season, media: Media) {
        self.id = season.id
        self.title = season.name
        self.subtitle = season.subtitle
        self.rating = season.voteAverage
        self.posterURL = season.posterURL ?? media.posterURL
        self.object = .season(season, tvShowID: media.id)
    }
}

