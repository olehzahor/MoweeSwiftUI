//
//  SectionView+Factory.swift
//  Movee
//
//  Created by Oleh on 27.10.2025.
//

import SwiftUI

extension SectionView {
    static func trailers(_ videos: [Video]?) -> SectionView where Content == NewMediaVideosCarouselView {
        SectionView(header: .init(title: "Trailers")) {
            NewMediaVideosCarouselView(videos: videos ?? [])
        }
    }
    
    static func medias(_ medias: [Media]?, section: NewMediasSection) -> SectionView where Content == MediasCarouselView {
        return SectionView(header: .init(section: section)) {
            MediasCarouselView(
                medias: (medias ?? []).map { .init(media: $0) }
            )
        }
    }
    
    static func seasons(_ seasons: [Season]?, media: Media?, section: NewMediasSection) -> SectionView where Content == MediasCarouselView {
        SectionView(header: .init(section: section)) {
            MediasCarouselView(
                medias: (seasons ?? []).compactMap {
                    guard let media else { return nil }
                    return .init(season: $0, media: media)
                }
            )
        }
    }
    
    static func reviews(_ reviews: [Review]?) -> SectionView where Content == NewMediaReviewsCarouselView {
        SectionView(header: .init(title: "Reviews")) {
            NewMediaReviewsCarouselView(reviews: reviews ?? [])
        }
    }
    
    static func castAndCrew(_ persons: [MediaPerson]?) -> SectionView where Content == PersonsCarouselView {
        SectionView(header: .init(title: "Cast and crew") {
            AnyView(MediaPersonsListView(persons: persons))
        }) {
            PersonsCarouselView(persons: persons ?? [])
        }
    }
}

extension SectionHeaderData {
    init(section: NewMediasSection) {
        self.init(
            title: section.title,
            action: section.dataProvider != nil ? { AnyView(NewMediasListView(section: section)) } : nil
        )
    }
}
