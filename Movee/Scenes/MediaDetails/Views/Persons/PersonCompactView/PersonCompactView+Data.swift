//
//  PersonCompactView+Data.swift
//  Movee
//
//  Created by user on 11/26/25.
//

import UIKit

extension PersonCompactView {
    struct Data {
        let pictureURL: URL?
        let name: String?
        let role: String?
        let placeholder: UIImage?
        
        init(pictureURL: URL? = nil, name: String? = nil, role: String? = nil, placeholder: UIImage? = nil) {
            self.pictureURL = pictureURL
            self.name = name
            self.role = role
            self.placeholder = placeholder
        }
    }
}

extension PersonCompactView.Data {
    init(_ person: MediaPerson) {
        self.pictureURL = person.profilePictureURL
        self.name = person.name
        self.role = person.role
        self.placeholder = person.placeholderImage
    }
}
