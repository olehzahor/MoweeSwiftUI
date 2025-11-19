//
//  SectionView+Factory.swift
//  Movee
//
//  Created by Oleh on 27.10.2025.
//

import SwiftUI

extension SectionView {
    static func trailers(_ videos: [Video]?) -> SectionView where Content == MediaVideosCarouselView {
        SectionView(header: .init(title: "Trailers")) {
            MediaVideosCarouselView(videos: videos ?? [])
        }
    }
    
    static func medias(_ medias: [Media]?, section: MediasSection) -> SectionView where Content == MediasCarouselView {
        return SectionView(header: .init(section: section)) {
            MediasCarouselView(
                medias: (medias ?? []).map { .init(media: $0) }
            )
        }
    }
    
    static func seasons(_ seasons: [Season]?, media: Media?, section: MediasSection) -> SectionView where Content == MediasCarouselView {
        SectionView(header: .init(section: section)) {
            MediasCarouselView(
                medias: (seasons ?? []).compactMap {
                    guard let media else { return nil }
                    return .init(season: $0, media: media)
                }
            )
        }
    }
    
    static func reviews(_ reviews: [Review]?) -> SectionView where Content == MediaReviewsCarouselView {
        SectionView(header: .init(title: "Reviews")) {
            MediaReviewsCarouselView(reviews: reviews ?? [])
        }
    }
    
    static func castAndCrew(_ persons: [MediaPerson]?) -> SectionView where Content == PersonsCarouselView {
        SectionView(header: .init(title: "Cast and crew") { coordinator in
            if let persons {
                coordinator?.push(.personsList(persons))
            }
        }) {
            PersonsCarouselView(persons: persons ?? [])
        }
    }
}

extension SectionHeaderData {
    init(section: MediasSection) {
        self.init(title: section.title) { coordinator in
            if section.dataProvider != nil {
                coordinator?.push(.mediasList(section))
            }
        }
    }
}
