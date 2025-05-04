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
    var duration: Int?
    var genres: String
    var mediaRating: Double?
    
    private var releaseDateString: String? {
        guard let releaseDate else { return nil }
        return MediaFormatterService.shared.format(date: releaseDate)
    }

    private var durationString: String? {
        guard let duration, duration > 0 else { return nil }
        return MediaFormatterService.shared.format(duration: duration)
    }
    
    private var subtitle: String {
        let strings = [releaseDateString, durationString].compactMap { $0 }
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
    
    init(media: Media) {
        title = media.title
        posterURL = media.posterURL
        releaseDate = media.parsedReleaseDate
        switch media.extra {
        case .movie(let movieExtra):
            duration = movieExtra.runtime
        case .tvShow(let tVShowExtra):
            if let runtimes = tVShowExtra.episodeRunTime, !runtimes.isEmpty {
                let total = runtimes.reduce(0, +)
                duration = Int(round(Double(total) / Double(runtimes.count)))
            } else {
                duration = nil
            }
        case .none:
            break
        }
        genres = media.genresString
        mediaRating = media.voteAverage
    }
}
