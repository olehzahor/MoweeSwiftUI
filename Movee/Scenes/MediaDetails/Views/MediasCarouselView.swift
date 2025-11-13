//
//  MediasCarouselView.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct MediasCarouselView: View {
    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool
    
    var medias: [MediaUIModel]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top) {
                if placeholder {
                    ForEach(0..<5, id: \.self) { _ in
                        MediaPosterView(.placeholder)
                            .loadable()
                    }
                } else {
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
            }
            .padding(.horizontal, horizontalPadding)
        }
        .padding(.horizontal, -horizontalPadding)
        .fallible()
    }
}
