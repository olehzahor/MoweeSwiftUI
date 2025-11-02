//
//  MediasCarouselView.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct MediasCarouselView: View {
    var medias: [MediaUIModel]
    var horizontalPadding: CGFloat = 20

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top) {
                ForEach(medias) { media in
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
        }
        .padding(.horizontal, -horizontalPadding)
    }
}

// MARK: - LoadableView conformance
extension MediasCarouselView: LoadableView {
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
        }
        .padding(.horizontal, -horizontalPadding)
    }
}

// MARK: - FailableView conformance
extension MediasCarouselView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
    }
}
