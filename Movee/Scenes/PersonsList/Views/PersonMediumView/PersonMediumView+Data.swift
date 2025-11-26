//
//  PersonMediumView+Data.swift
//  Movee
//
//  Created by user on 11/26/25.
//

import UIKit

extension PersonMediumView {
    struct Data {
        let name: String
        let role: String?
        let profilePictureURL: URL?
        let placeholderImage: UIImage?
    }
}

extension PersonMediumView.Data {
    init(_ person: MediaPerson) {
        self.name = person.name
        self.role = person.role
        self.profilePictureURL = person.profilePictureURL
        self.placeholderImage = person.placeholderImage
    }
}
