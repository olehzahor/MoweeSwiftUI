//
//  MediaRowView+DataModel.swift
//  Movee
//
//  Created by user on 5/2/25.
//

import Foundation
import UIKit

extension MediaRowView {
    struct DataModel {
        let title: String
        let subtitle: String?
        let posterURL: URL?
        let placeholder: UIImage?
        let overview: String
        
        init(media: Media) {
            self.title = media.title
            if let subtitle = media.subtitle, !subtitle.isEmpty {
                self.subtitle = media.subtitle
            } else {
                self.subtitle = "\(media.releaseYear) · \(media.genresString)"
            }
            self.posterURL = media.posterURL
            self.overview = media.overview
            self.placeholder = .imageMoviePlaceholder
        }
        
        init(person: MediaPerson) {
            self.title = person.name
            self.subtitle = person.department
            self.posterURL = person.profilePictureURL
            self.overview = person.knownFor?.map({ $0.title }).joined(separator: "\n") ?? ""
            self.placeholder = person.placeholderImage
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
        
    }
}
