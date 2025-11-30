//
//  MediaDetailsViewModel.swift
//  Movee
//
//  Created by Oleh on 19.10.2025.
//

import Foundation
import Factory

@MainActor @Observable
final class MediaDetailsViewModel {
    private let repo: MediaDetailsRepositoryProtocol
    private let watchlist: WatchlistRepository
    private let searchHistory: SearchHistoryRepository

    private var mediaIdentifier: MediaIdentifier

    enum Section: CaseIterable {
        case details, seasons, videos, credits, related, reviews, collection
    }
    let loader: SectionLoader<Section>

    var isInWatchlist: Bool?

    var media: Media?
    var seasons = SectionData<Season>(name: "Seasons")
    var credits: [MediaPerson]?
    var related: SectionData<Media>
    var reviews: [Review]?
    var videos: [Video]?
    var collection = SectionData<Media>(name: "Collection")
    
    @ObservationIgnored
    private lazy var fetchConfigs: [Section: FetchConfig] = [
        .details: .init(
            priority: 0,
            fetch: { [repo, mediaIdentifier] in
                try await repo.fetchMedia(mediaIdentifier)
            },
            update: { [weak self] media in
                self?.media = media
                self?.saveToSearchHistory()
                
                if self?.isInWatchlist == nil {
                    self?.loadWatchlistStatus()
                }
            }
        ),
        .seasons: .init(
            fetch: { [weak self] in
                self?.media?.seasons ?? []
            },
            update: { [weak self] seasons in
                self?.seasons.items = seasons
            }
        ),
        .related: .init(
            fetch: { [repo, mediaIdentifier] in
                try await repo.fetchRelated(mediaIdentifier)
            },
            update: { [weak self] related in
                self?.related.items = related
            }
        ),
        .credits: .init(
            fetch: { [repo, mediaIdentifier] in
                try await repo.fetchCredits(mediaIdentifier)
            },
            update: { [weak self] credits in
                self?.credits = credits
            }
        ),
        .reviews: .init(
            fetch: { [repo, mediaIdentifier] in
                try await repo.fetchReviews(mediaIdentifier)
            },
            update: { [weak self] reviews in
                self?.reviews = reviews
            }
        ),
        .videos: .init(
            fetch: { [repo, mediaIdentifier] in
                try await repo.fetchVideos(mediaIdentifier)
            },
            update: { [weak self] videos in
                self?.videos = videos
            }
        ),
        .collection: .init(
            fetch: { [weak self, repo] in
                try await repo.fetchCollection(self?.media)
            },
            update: { [weak self] collection in
                guard let collection else { return }
                self?.collection.update(with: collection)
            }, isEmpty: { collection in
                collection?.medias.isEmpty ?? true
            }
        )
    ]
    
    private func setupSectionsContext() {
        if mediaIdentifier.type != .tvShow {
            loader.updateLoadState(for: .seasons, .loaded(isEmpty: true))
        }
    }

    private func saveToSearchHistory() {
        Task {
            guard let media else { return }
            await searchHistory.add(media)
        }
    }

    init(mediaID: Int, mediaType: MediaType,
         repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository(),
         watchlist: WatchlistRepository = Container.shared.watchlistRepository(),
         searchHistory: SearchHistoryRepository = Container.shared.searchHistoryRepository()) {
        let mediaIdentifier = MediaIdentifier(id: mediaID, type: mediaType)
        self.mediaIdentifier = mediaIdentifier

        self.repo = repo
        self.watchlist = watchlist
        self.searchHistory = searchHistory

        self.related = .init(
            name: "Related",
            dataProvider: TypedMediasListDataProvider.related(mediaIdentifier)
        )

        self.loader = SectionLoader(
            sections: Section.allCases,
            maxConcurrent: 3
        )
        self.loader.setConfigs(fetchConfigs)

        setupSectionsContext()
        loadWatchlistStatus()
    }

    convenience init(media: Media,
                     repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository()) {
        self.init(mediaID: media.id, mediaType: media.mediaType, repo: repo)
        self.media = media
    }
}

extension MediaDetailsViewModel: MediaDetailsWatchlistManager {
    private func loadWatchlistStatus() {
        Task {
            isInWatchlist = await watchlist.contains(mediaIdentifier.id)
        }
    }

    func toggleWatchlist() {
        Task {
            guard let media else { return }
            await watchlist.toggle(media)
            loadWatchlistStatus()
        }
    }
}
