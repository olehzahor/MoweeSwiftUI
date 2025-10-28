//
//  MediaDetailedInfoView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct MediaDetailedInfoView: View {
    var title: String
    var posterURL: URL?
    var releaseDate: String?
    var duration: String?
    var genres: String
    var mediaRating: Double?

    private var subtitle: String {
        let strings = [releaseDate, duration].compactMap { $0 }
        var string = strings.joined(separator: " · ")
        if !string.isEmpty {
            string += "\n"
        }
        if !genres.isEmpty {
            string += "\(genres)"
        }
        return string
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            MediaPosterView(.init(posterURL: posterURL, rating: mediaRating))
            Spacer()
            VStack(spacing: 8) {
                Text(title)
                    .textStyle(.mediaLargeTitle)
                    .lineLimit(3)
                Text(subtitle)
                    .textStyle(.smallText)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    
    init(title: String, posterURL: URL? = nil, releaseDate: String? = nil, duration: String? = nil, genres: String, mediaRating: Double? = nil) {
        self.title = title
        self.posterURL = posterURL
        self.releaseDate = releaseDate
        self.duration = duration
        self.genres = genres
        self.mediaRating = mediaRating
    }
}

extension MediaDetailedInfoView: LoadableView {
    func loadingView() -> some View {
        Self(media: .placeholder)
            .shimmering()
//        HStack(alignment: .bottom) {
//            MediaPosterView(.init(posterURL: posterURL, rating: mediaRating))
//                .shimmering()
//            Spacer()
//            VStack(spacing: 8) {
//                Text(String.placeholder(.short))
//                    .textStyle(.mediaLargeTitle)
//                    .shimmering()
//                    .redacted(reason: .placeholder)
//                Text(String.placeholder(.medium))
//                    .textStyle(.smallText)
//                    .shimmering()
//                    .redacted(reason: .placeholder)
//            }
//            Spacer()
//        }
//        .padding(.horizontal, 20)
    }
}

extension MediaDetailedInfoView {
    init(media: Media) {
        title = media.title
        posterURL = media.posterURL
        releaseDate = media.releaseDateString
        duration = media.durationString
        genres = media.genresString
        mediaRating = media.voteAverage
    }
}
