//
//  WatchlistView+Preview.swift
//  Movee
//
//  Created by user on 11/17/25.
//

import SwiftUI
import Factory

#if DEBUG
#Preview("Empty Watchlist") {
    NavigationStack {
        WatchlistView()
    }
}

#Preview("With Items") {
    NavigationStack {
        WatchlistView()
    }
    .onAppear {
        Task { @MainActor in
            let repo = Container.shared.watchlistRepository()
            await repo.add(Media(
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
            ))
        }
    }
}
#endif
