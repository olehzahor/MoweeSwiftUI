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
    var releaseDate: Date?
    var duration: Int
    var genres: String
    var mediaRating: Double?
    
    private var releaseDateString: String {
        MediaFormatterService.shared.format(date: releaseDate)
    }

    private var durationString: String {
        MediaFormatterService.shared.format(duration: duration)
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            MediaPosterView(.init(posterURL: posterURL, rating: mediaRating))
            Spacer()
            VStack(spacing: 8) {
                Text(title)
                    .textStyle(.mediaLargeTitle)
                    .lineLimit(3)
                Text("\(releaseDateString) · \(durationString)\n\(genres)")
                    .textStyle(.smallText)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    init(media: Media) {
        title = media.title
        posterURL = media.posterURL
        releaseDate = media.parsedReleaseDate
        duration = 122
        genres = media.genresString
        mediaRating = media.voteAverage
    }
}
