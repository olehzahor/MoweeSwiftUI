//
//  PersonCompactView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct PersonCompactView: View {
    let pictureURL: URL?
    let name: String?
    let role: String?
    let placeholder: UIImage?
    
    var body: some View {
        VStack {
            AsyncImageView(
                url: pictureURL,
                width: 100,
                height: 100,
                cornerRadius: 50,
                placeholder: placeholder
            )
            if let name {
                Text(name)
                    .textStyle(.smallTitle)
            }
            if let role {
                Text(role)
                    .textStyle(.smallSubtitle)
            }
            Spacer()
        }
        .frame(maxHeight: 185)
        .frame(width: 100)
    }
    
    init(person: MediaPerson) {
        self.pictureURL = person.profilePictureURL
        self.name = person.name
        self.role = person.role
        self.placeholder = person.placeholderImage
    }
}
