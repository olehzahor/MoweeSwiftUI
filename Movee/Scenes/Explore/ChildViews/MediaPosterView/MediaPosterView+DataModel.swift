//
//  NavigationAction.swift
//  Movee
//
//  Created by user on 4/30/25.
//

import Foundation

extension MediaPosterView {
    struct DataModel: Identifiable {
        enum Object {
            case media(Media)
            case season(Season)
        }

        var id: Int = -1
        var title: String?
        var subtitle: String?
        var posterURL: URL?
        var rating: Double?
        var object: Object?
    }
}

extension MediaPosterView.DataModel {
    static var placeholder = Self(title: .placeholder(.short))
    
    init(media: Media) {
        self.id = media.id
        self.title = media.title
        self.subtitle = nil
        self.posterURL = media.posterURL
        self.rating = media.voteAverage
        self.object = .media(media)
    }
    
    init(season: Season) {
        self.id = season.id
        self.title = season.name
        self.subtitle = season.subtitle
        self.posterURL = season.posterURL
        self.object = .season(season)
    }
}

