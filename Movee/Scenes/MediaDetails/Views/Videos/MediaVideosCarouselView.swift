//
//  MediaVideosCarouselView.swift
//  Movee
//
//  Created on 24.10.2025.
//

import SwiftUI

struct MediaVideosCarouselView: View {
    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool

    let videos: [Video]
    
    @ViewBuilder
    private func carouselContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                content()
                    .containerRelativeFrame(.horizontal)
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, horizontalPadding, for: .scrollContent)
        .padding(.horizontal, -horizontalPadding)
    }

    var body: some View {
        carouselContainer {
            if placeholder {
                ForEach(0..<3, id: \.self) { _ in
                    MediaVideoView(data: .placeholder)
                }
            } else {
                ForEach(videos, id: \.id) { video in
                    MediaVideoView(data: .init(video: video))
                }
            }
        }
        .fallible()
    }
    
    init(videos: [Video]) {
        self.videos = videos
    }
}
