//
//  NewPersonsSectionView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI

struct NewPersonsSectionView: View {
    var persons: [MediaPerson]?
    var horizontalPadding: CGFloat

    private var header: SectionHeaderData {
        SectionHeaderData(
            title: "Cast and crew",
            isButtonHidden: persons == nil,
            action: persons != nil ? { AnyView(MediaPersonsListView(persons: persons ?? [])) } : nil
        )
    }

    var body: some View {
        SectionView(header: header) {
            PersonsCarouselView(
                persons: persons ?? [],
                horizontalPadding: horizontalPadding
            )
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

// MARK: - LoadableView conformance
extension NewPersonsSectionView: LoadableView {
    func loadingView() -> some View {
        SectionView(header: header) {
            PersonsCarouselView(
                persons: persons ?? [],
                horizontalPadding: horizontalPadding
            )
        }
        .loadingView()
    }
}

// MARK: - FailableView conformance
extension NewPersonsSectionView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        SectionView(header: header) {
            PersonsCarouselView(
                persons: persons ?? [],
                horizontalPadding: horizontalPadding
            )
        }
        .errorView(error: error, retry: retry)
    }
}
