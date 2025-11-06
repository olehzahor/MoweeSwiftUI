//
//  MediaUIModel.swift
//  Movee
//
//  Created by user on 5/3/25.
//

import Foundation
import UIKit

struct MediaUIModel: Identifiable {
    enum Object {
        case media(Media)
        case season(Season, Media)
        case credit(PersonCredit)
        case person(MediaPerson)
    }
    
    var id: Int = -1
    var title: String?
    var subtitle: String?
    var details: String?
    var overview: String?
    var posterURL: URL?
    var placeholder: UIImage?
    var rating: Double?
    var object: Object?
}

extension MediaUIModel {
    init(media: Media) {
        self.id = media.id
        self.title = media.title
        self.subtitle = media.subtitle
        self.details = media.subtitle ?? media.detailsString
        self.overview = media.overview
        self.posterURL = media.posterURL
        self.placeholder = .imageMoviePlaceholder
        self.rating = media.voteAverage
        self.object = .media(media)
    }
    
    init(season: Season, media: Media) {
        self.id = season.id
        self.title = season.name
        self.subtitle = season.subtitle
        self.overview = season.overview
        self.posterURL = season.posterURL ?? media.posterURL
        self.placeholder = .imageMoviePlaceholder
        self.rating = season.voteAverage
        self.object = .season(season, media)
    }
    
    init(person: MediaPerson) {
        self.id = person.id
        self.title = person.name
        self.subtitle = person.department
        self.posterURL = person.profilePictureURL
        self.overview = person.knownFor?.map({ $0.media.title }).joined(separator: "\n") ?? ""
        self.placeholder = person.placeholderImage
        self.rating = nil
        self.object = .person(person)
    }
    
    init(searchResult: SearchResult) {
        switch searchResult.result {
        case .movie(let movie):
            let mediaModel = Media(movie: movie)
            self = .init(media: mediaModel)
        case .tv(let tvShow):
            let mediaModel = Media(tvShow: tvShow)
            self = .init(media: mediaModel)
        case .person(let person):
            let personModel = MediaPerson(person: person)
            self = .init(person: personModel)
        }
    }
        
    static var placeholder = Self(media: .placeholder)
}
