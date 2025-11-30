//
//  MediasCarouselView.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct MediasCarouselView: View {
    typealias OnSelectClosure = (Data.Link?) -> Void

    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool
    @Environment(\.coordinator) private var coordinator
    
    let items: [Data]
    
    private let onSelect: OnSelectClosure?
    
    func handleSelection(_ link: Data.Link?) {
        if let onSelect {
            onSelect(link)
        } else if let coordinator {
            switch link {
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
            LazyHStack(alignment: .top) {
                if placeholder {
                    ForEach(0..<5, id: \.self) { _ in
                        MediaPosterView(data: .init(media: .placeholder))
                            .loadable()
                    }
                } else {
                    ForEach(items) { item in
                        Button {
                            handleSelection(item.link)
                        } label: {
                            MediaPosterView(data: item.data)
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

extension MediasCarouselView {
    init(medias: [Media], onSelect: OnSelectClosure? = nil) {
        self.items = medias.map { .init(media: $0) }
        self.onSelect = onSelect
    }
    
    init(seasons: [Season], media: Media?, onSelect: OnSelectClosure? = nil) {
        self.items = seasons.map { .init(season: $0, media: media) }
        self.onSelect = onSelect
    }
}
