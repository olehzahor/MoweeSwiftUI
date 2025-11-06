//
//  PersonsCarouselView.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct PersonsCarouselView: View {
    var persons: [MediaPerson]
    var horizontalPadding: CGFloat = 20

    private var carousel: [MediaPerson] {
        Array(persons.filter({ $0.profilePictureURL != nil }).prefix(50))
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(carousel, id: \.creditID) { person in
                    NavigationLink {
                        NewPersonDetailsView(person: person)
                    } label: {
                        PersonCompactView(person: person)
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.horizontal, -horizontalPadding)
    }
}

// MARK: - LoadableView conformance
extension PersonsCarouselView: LoadableView {
    func loadingView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(0..<5, id: \.self) { _ in
                    PersonCompactView(person: MediaPerson.placeholder)
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.horizontal, -horizontalPadding)
    }
}

// MARK: - FailableView conformance
extension PersonsCarouselView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
    }
}
