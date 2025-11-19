//
//  MediasCarouselView.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct MediasCarouselView: View {
    typealias OnSelectClosure = (MediaUIModel.Object?) -> Void

    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool
    @Environment(\.coordinator) private var coordinator

    var medias: [MediaUIModel]
    private let onSelect: OnSelectClosure?

    func handleSelection(_ mediaObject: MediaUIModel.Object?) {
        if let onSelect {
            onSelect(mediaObject)
        } else if let coordinator {
            switch mediaObject {
            case .media(let media):
                coordinator.push(.mediaDetails(media))
            case .season(let season, let media):
                coordinator.push(.seasonDetails(media.id, season))
            default:
                return
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                if placeholder {
                    ForEach(0..<5, id: \.self) { _ in
                        MediaPosterView(.placeholder)
                            .loadable()
                    }
                } else {
                    ForEach(medias) { media in
                        Button {
                            handleSelection(media.object)
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
    
    init(medias: [MediaUIModel], onSelect: OnSelectClosure? = nil) {
        self.medias = medias
        self.onSelect = onSelect
    }
}
