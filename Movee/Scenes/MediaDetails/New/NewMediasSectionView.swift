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

    @ViewBuilder
    private func sectionContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            if let section {
                SectionHeaderView(
                    title: section.title,
                    isButtonHidden: false) {
                        AnyView(NewMediasListView(section: section))
                    }
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
            ForEach(medias ?? []) { media in
                NavigationLink {
                    switch media.object {
                    case .media(let media):
                        NewMediaDetailsView(media: media)
                    case .season(let season, let media):
                        SeasonDetailsView(tvShowID: media.id, season: season)
                    default:
                        EmptyView()
                    }
                } label: {
                    MediaPosterView(media)
                }
            }
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

// MARK: - Loadable conformance
extension NewMediasSectionView: LoadableView {
    func loadingView() -> some View {
        sectionContainer {
            ForEach(0..<5, id: \.self) { _ in
                MediaPosterView(.placeholder)
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
    }
}

// MARK: - Failable conformance
extension NewMediasSectionView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
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
