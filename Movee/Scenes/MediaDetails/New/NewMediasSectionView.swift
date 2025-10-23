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
            
    var body: some View {
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
                .padding(.horizontal, horizontalPadding)
            }.padding(.horizontal, -horizontalPadding)
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(0..<5, id: \.self) { _ in
                    MediaPosterView(.placeholder)
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
            }
            .padding(.horizontal, horizontalPadding)
        }.padding(.horizontal, -horizontalPadding)
    }
}

// MARK: - Failable conformance
extension NewMediasSectionView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        VStack(spacing: 10) {
            Text("Error: \(error.localizedDescription)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("Retry", action: retry ?? {})
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
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
