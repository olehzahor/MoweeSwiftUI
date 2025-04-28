//
//  PersonsCarouselView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct PersonsSectionView: View {
    private var isPlaceholder: Bool
    
    var persons: [MediaPerson] = []
    var carousel: [MediaPerson] = []
    var horizontalPadding: CGFloat = 20
        
    var body: some View {
        VStack {
            SectionHeaderView(
                title: "Cast and crew",
                isButtonHidden: isPlaceholder) {
                AnyView(MediaPersonsListView(persons: persons))
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    if isPlaceholder {
                        ForEach(0..<5, id: \.self) { _ in
                            PersonCompactView(person: MediaPerson.placeholder)
                                .redacted(reason: .placeholder)
                                .shimmering()
                        }
                    } else {
                        ForEach(carousel, id: \.creditID) { person in
                            NavigationLink {
                                PersonDetailsView(person: person)
                            } label: {
                                PersonCompactView(person: person)
                            }
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .animation(.easeOut(duration: 0.25), value: persons.isEmpty)
            }
            .padding(.horizontal, -horizontalPadding)
        }
    }
    
    init(persons: [MediaPerson]? = [], horizontalPadding: CGFloat = 20) {
        self.persons = persons ?? []
        self.carousel = Array(self.persons.filter({ $0.profilePictureURL != nil }).prefix(50))
        self.isPlaceholder = persons == nil
        self.horizontalPadding = horizontalPadding
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
