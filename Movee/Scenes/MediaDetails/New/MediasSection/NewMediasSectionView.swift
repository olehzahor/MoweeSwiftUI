//
//  NewMediasSectionView.swift
//  Movee
//
//  Created by Oleh on 23.10.2025.
//

import SwiftUI

struct NewMediasSectionView: View {
    let section: NewMediasSection?
    let medias: [MediaUIModel]?
    var horizontalPadding: CGFloat

    private var header: SectionHeaderData {
        guard let section else {
            return SectionHeaderData(title: "", isButtonHidden: true)
        }
        return SectionHeaderData(
            title: section.title,
            isButtonHidden: section.dataProvider == nil,
            action: section.dataProvider != nil ? { AnyView(NewMediasListView(section: section)) } : nil
        )
    }

    var body: some View {
        SectionView(header: header) {
            MediasCarouselView(
                medias: medias ?? [],
                horizontalPadding: horizontalPadding
            )
        }
    }

    init(
        section: NewMediasSection?,
        items: [MediaUIModel]?,
        horizontalPadding: CGFloat = 20
    ) {
        self.section = section
        self.medias = items
        self.horizontalPadding = horizontalPadding
    }
}

// MARK: - LoadableView conformance
extension NewMediasSectionView: LoadableView {
    func loadingView() -> some View {
        SectionView(header: header) {
            MediasCarouselView(
                medias: medias ?? [],
                horizontalPadding: horizontalPadding
            )
        }
        .loadingView()
    }
}

// MARK: - FailableView conformance
extension NewMediasSectionView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        SectionView(header: header) {
            MediasCarouselView(
                medias: medias ?? [],
                horizontalPadding: horizontalPadding
            )
        }
        .errorView(error: error, retry: retry)
    }
}

// MARK: - Convenience Initializers
extension NewMediasSectionView {
    init(
        section: NewMediasSection?,
        medias: [Media]?,
        horizontalPadding: CGFloat = 20
    ) {
        self.init(
            section: section,
            items: medias?.map { .init(media: $0) },
            horizontalPadding: horizontalPadding
        )
    }

    init(
        section: NewMediasSection?,
        seasons: [Season]?,
        media: Media?,
        horizontalPadding: CGFloat = 20
    ) {
        let items: [MediaUIModel]? = {
            guard let media = media else { return nil }
            return seasons?.map { .init(season: $0, media: media) }
        }()

        self.init(
            section: section,
            items: items,
            horizontalPadding: horizontalPadding
        )
    }
}
