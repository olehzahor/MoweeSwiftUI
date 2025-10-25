//
//  NewPersonsSectionView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI

struct NewPersonsSectionView: View {
    var persons: [MediaPerson]?
    var carousel: [MediaPerson] {
        guard let persons = persons else { return [] }
        return Array(persons.filter({ $0.profilePictureURL != nil }).prefix(50))
    }
    var horizontalPadding: CGFloat

    @ViewBuilder
    private func sectionContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            SectionHeaderView(
                title: "Cast and crew",
                isButtonHidden: persons == nil) {
                    AnyView(MediaPersonsListView(persons: persons ?? []))
                }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    content()
                }
                .padding(.horizontal, horizontalPadding)
            }.padding(.horizontal, -horizontalPadding)
        }
    }

    var body: some View {
        sectionContainer {
            ForEach(carousel, id: \.creditID) { person in
                NavigationLink {
                    PersonDetailsView(person: person)
                } label: {
                    PersonCompactView(person: person)
                }
            }
        }
    }

    init(
        persons: [MediaPerson]?,
        horizontalPadding: CGFloat = 20
    ) {
        self.persons = persons
        self.horizontalPadding = horizontalPadding
    }
}

// MARK: - Loadable conformance
extension NewPersonsSectionView: LoadableView {
    func loadingView() -> some View {
        sectionContainer {
            ForEach(0..<5, id: \.self) { _ in
                PersonCompactView(person: MediaPerson.placeholder)
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
    }
}

// MARK: - Failable conformance
extension NewPersonsSectionView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
    }
}
