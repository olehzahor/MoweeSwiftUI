//
//  NewMediaDetailsViewModel.swift
//  Movee
//
//  Created by Oleh on 19.10.2025.
//

import Foundation

@MainActor protocol MediaDetailsWatchlistManager {
    var isInWatchlist: Bool? { get }
    func toggleWatchlist()
}

@MainActor @Observable
final class NewMediaDetailsViewModel: SectionFetchable, FailedSectionsReloadable, ObservableObject {
    private let repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository()

    private var mediaIdentifier: MediaIdentifier
    
    var isInWatchlist: Bool?

    var media: Media?
    var seasons: SectionData<Season>
    var credits: [MediaPerson]?
    var related: SectionData<Media>
    var reviews: [Review]?
    var videos: [Video]?
    var collection: SectionData<Media>
    
    var maxConcurrentFetches: Int { 3 }
    private(set) var fetchableSections: [MediaDetailsSection] = SectionType.allCases
    
    var sectionsContext = AsyncLoadingContext<MediaDetailsSection>()
    
    @ObservationIgnored
    private(set) lazy var fetchConfigs: [MediaDetailsSection: AnyFetchConfig] = [
        .details: AnyFetchConfig(
            FetchConfig(priority: 0) { [repo, mediaIdentifier] in
                try await repo.fetchMedia(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.media = result
                self?.loadWatchlistStatus()
            }
        ),
        .seasons: AnyFetchConfig(
            FetchConfig { [unowned self] in
                media?.seasons ?? []
            } onSuccess: { [weak self] result in
                self?.seasons.items = result
            }
        ),
        .related: AnyFetchConfig(
            FetchConfig { [repo, mediaIdentifier] in
                try await repo.fetchRelated(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.related.items = result
            }
        ),
        .credits: AnyFetchConfig(
            FetchConfig { [repo, mediaIdentifier] in
                try await repo.fetchCredits(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.credits = result
            }
        ),
        .reviews: AnyFetchConfig(
            FetchConfig { [repo, mediaIdentifier] in
                try await repo.fetchReviews(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.reviews = result
            }
        ),
        .videos: AnyFetchConfig(
            FetchConfig { [repo, mediaIdentifier] in
                try await repo.fetchVideos(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.videos = result
            }
        ),
        .collection: AnyFetchConfig(
            FetchConfig { [unowned self] in
                try await repo.fetchCollection(media)
            } onSuccess: { [weak self] result in
                guard let result else { return }
                self?.collection.update(with: result)
            } isEmpty: { result in
                result?.medias.isEmpty ?? true
            }
        )
    ]
    
    func fetchConfig(for section: MediaDetailsSection) -> AnyFetchConfig? {
        fetchConfigs[section]
    }

    private func setupSectionsContext() {
        if mediaIdentifier.type != .tvShow {
            sectionsContext[.seasons] = .loaded(isEmpty: true)
        }
    }
        
    init(mediaID: Int, mediaType: MediaType) {
        let mediaIdentifier = MediaIdentifier(id: mediaID, type: mediaType)
        self.mediaIdentifier = mediaIdentifier
                
        self.seasons = .init(name: "Seasons")
        self.related = .init(
            name: "Related",
            dataProvider: TypedMediasListDataProvider.related(mediaIdentifier)
        )
        self.collection = .init(name: "Collection")

        setupSectionsContext()
    }
    
    convenience init(media: Media) {
        self.init(mediaID: media.id, mediaType: media.mediaType)
        self.media = media
        loadWatchlistStatus()
    }
}

extension NewMediaDetailsViewModel: MediaDetailsWatchlistManager {
    private func loadWatchlistStatus() {
        guard let media else { return }
        Task {
            isInWatchlist = await WatchlistManager.shared.isInWatchlist(media)
        }
    }

    func toggleWatchlist() {
        guard let media else { return }
        Task {
            await WatchlistManager.shared.toggleWatchlist(media)
            loadWatchlistStatus()
        }
    }
}
