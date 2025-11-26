//
//  PersonsCarouselView.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct PersonsCarouselView: View {
    typealias OnSelectClosure = (MediaPerson) -> Void

    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool
    @Environment(\.coordinator) private var coordinator

    var persons: [MediaPerson]
    private let onSelect: OnSelectClosure?

    private var carousel: [MediaPerson] {
        Array(persons.filter({ $0.profilePictureURL != nil }).prefix(50))
    }

    func handleSelection(_ person: MediaPerson) {
        if let onSelect {
            onSelect(person)
        } else if let coordinator {
            coordinator.push(.personDetails(person))
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top) {
                if placeholder {
                    ForEach(0..<5, id: \.self) { _ in
                        PersonCompactView(data: .init(MediaPerson.placeholder))
                    }
                } else {
                    ForEach(carousel, id: \.creditID) { person in
                        Button {
                            handleSelection(person)
                        } label: {
                            PersonCompactView(data: .init(person))
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

    init(persons: [MediaPerson], onSelect: OnSelectClosure? = nil) {
        self.persons = persons
        self.onSelect = onSelect
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
