//
//  Data.swift
//  Movee
//
//  Created by user on 11/27/25.
//

extension MediasCarouselView {
    struct Data: Identifiable {
        enum Link {
            case media(Media)
            case season(Season, Media)
        }
        
        let id: Int
        let link: Link?
        let data: MediaPosterView.Data
    }
}

extension MediasCarouselView.Data {
    init(media: Media) {
        id = media.id
        link = .media(media)
        data = .init(media: media)
    }
    
    init(season: Season, media: Media?) {
        id = season.id
        if let media {
            link = .season(season, media)
        } else {
            link = nil
        }
        data = .init(season: season, media: media)
    }
}
