//
//  Data.swift
//  Movee
//
//  Created by user on 11/26/25.
//

import UIKit

extension PersonRowView {
    struct Data {
        struct Media: Hashable {
            let title: String
            let posterURL: URL?
        }
        
        let name: String
        let department: String?
        let pictureURL: URL?
        let picturePlaceholder: UIImage?
        let knownFor: [Self.Media]
    }
}

extension PersonRowView.Data {
    init(_ person: MediaPerson) {
        self.name = person.name
        self.department = person.department
        self.pictureURL = person.profilePictureURL
        self.picturePlaceholder = person.placeholderImage
        self.knownFor = (person.knownFor ?? []).map { credit in
            Media(
                title: credit.media.title,
                posterURL: credit.media.posterURL
            )
        }
    }
}
