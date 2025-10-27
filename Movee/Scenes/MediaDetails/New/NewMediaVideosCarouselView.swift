//
//  NewMediaVideosCarouselView.swift
//  Movee
//
//  Created on 24.10.2025.
//

import SwiftUI

struct NewMediaVideosCarouselView: View {
    let videos: [Video]
    private let horizontalPadding: CGFloat = 20
    
    @ViewBuilder
    private func carouselContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    content()
                        .containerRelativeFrame(.horizontal)
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, horizontalPadding, for: .scrollContent)
            .padding(.horizontal, -horizontalPadding)
        }
    }

    var body: some View {
        carouselContainer {
            ForEach(videos, id: \.id) { video in
                NewMediaVideoView(data: .init(video: video))
            }
        }
    }
}

// MARK: - LoadableView conformance
extension NewMediaVideosCarouselView: LoadableView {
    func loadingView() -> some View {
        carouselContainer {
            ForEach(0..<3, id: \.self) { _ in
                NewMediaVideoView(data: .placeholder)
                    .shimmering()
                    .disabled(true)
            }
        }
    }
}

// MARK: - FailableView conformance
extension NewMediaVideosCarouselView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
    }
}
