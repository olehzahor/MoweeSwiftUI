//
//  MediaDetailsView+Preview.swift
//  Movee
//
//  Created by user on 11/17/25.
//

import SwiftUI

#if DEBUG

// MARK: - Sample Media Data
private extension Media {
    static let fightClub = Media(
        id: 550,
        mediaType: .movie,
        title: "Fight Club",
        originalTitle: "Fight Club",
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy.",
        posterPath: "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
        backdropPath: "/hZkgoQYus5vegHoetLkCJzb17zJ.jpg",
        popularity: 63.869,
        voteAverage: 8.433,
        voteCount: 26280,
        releaseDate: "1999-10-15",
        genreIDs: [18, 53, 35]
    )

    static let breakingBad = Media(
        id: 1396,
        mediaType: .tvShow,
        title: "Breaking Bad",
        originalTitle: "Breaking Bad",
        overview: "Walter White, a chemistry teacher, discovers that he has cancer and decides to get into the meth-making business.",
        posterPath: "/3xnWaLQjelJDDF7LT1X7ZLyf7UP1M.jpg",
        backdropPath: "/tsRy63Mu5cu8etL1X7ZLyf7UP1M.jpg",
        popularity: 451.147,
        voteAverage: 8.9,
        voteCount: 13042,
        releaseDate: "2008-01-20",
        genreIDs: [18, 80]
    )
}

// MARK: - Previews
#Preview("Movie - With Media Object") {
    NavigationStack {
        MediaDetailsView(media: .fightClub)
    }
}

#Preview("Movie - With ID & Type") {
    NavigationStack {
        MediaDetailsView(mediaID: 550, mediaType: .movie)
    }
}

#Preview("TV Show - With Media Object") {
    NavigationStack {
        MediaDetailsView(media: .breakingBad)
    }
}

#Preview("TV Show - With ID & Type") {
    NavigationStack {
        MediaDetailsView(mediaID: 1396, mediaType: .tvShow)
    }
}

#endif
