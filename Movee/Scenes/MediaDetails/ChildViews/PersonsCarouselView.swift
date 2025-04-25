//
//  PersonsCarouselView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct PersonsCarouselView: View {
    var persons: [MediaPerson]
    var horizontalPadding: CGFloat = 20
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                if persons.isEmpty {
                    ForEach(0..<5, id: \.self) { _ in
                        PersonCompactView(person: MediaPerson.placeholder)
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                } else {
                    ForEach(persons) { person in
                        NavigationLink {
                            PersonDetailsView(person: person)
                        } label: {
                            PersonCompactView(person: person)
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .animation(.easeOut, value: persons.isEmpty)
        }
        .padding(.horizontal, -horizontalPadding)
    }
}

// MARK: - MediaPerson placeholder
extension MediaPerson {
    static let placeholder = MediaPerson(
        person: Person(
            id: -1,
            name: "##########",
            profilePath: nil)
    )
}
