//
//  PersonMediumView.swift
//  Movee
//
//  Created by user on 4/17/25.
//

import SwiftUI

struct PersonMediumView: View {
    var person: MediaPerson
    
    var body: some View {
        VStack(alignment: .center) {
            AsyncImageView(
                url: person.profilePictureURL,
                placeholder: person.placeholderImage
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .aspectRatio(2/3, contentMode: .fit)
            Text(person.name)
                .textStyle(.smallTitle)
            if let role = person.role {
                Text(role)
                    .textStyle(.smallSubtitle)
            }
        }
    }
}

#Preview {
    PersonMediumView(person: MediaPerson(
        id: 1,
        type: .cast,
        name: "John Doe",
        profilePath: "/sampleProfile1.jpg",
        role: "Director",
        creditID: "credit123",
        gender: 2,
        castID: nil,
        order: nil
    ))
}
