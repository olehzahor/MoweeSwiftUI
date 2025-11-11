//
//  PersonsCarouselView.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct PersonsCarouselView: View {
    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool

    var persons: [MediaPerson]

    private var carousel: [MediaPerson] {
        Array(persons.filter({ $0.profilePictureURL != nil }).prefix(50))
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                if placeholder {
                    ForEach(0..<5, id: \.self) { _ in
                        PersonCompactView(person: MediaPerson.placeholder)
                    }
                } else {
                    ForEach(carousel, id: \.creditID) { person in
                        NavigationLink {
                            NewPersonDetailsView(person: person)
                        } label: {
                            PersonCompactView(person: person)
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.horizontal, -horizontalPadding)
        .loadable()
        .fallible()
    }
}
