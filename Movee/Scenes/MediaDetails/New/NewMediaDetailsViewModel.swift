//
//  NewMediaDetailsViewModel.swift
//  Movee
//
//  Created by Oleh on 19.10.2025.
//

import Foundation

@MainActor
final class NewMediaDetailsViewModel: SectionFetchable, FailedSectionsReloadable, ObservableObject {
    private let repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository()

    private var mediaIdentifier: MediaIdentifier

    @Published var media: Media?
    @Published var seasons: MediasSection<Season>
    @Published var credits: [MediaPerson]?
    @Published var related: MediasSection<Media>
    @Published var reviews: [Review]?
    @Published var videos: [Video]?
    @Published var collection: MediasSection<Media>
    
    var maxConcurrentFetches: Int { 3 }

    @Published var sectionsContext = AsyncLoadingContext<MediaDetailsSection>()

    private(set) lazy var fetchConfigs: [MediaDetailsSection: AnyFetchConfig] = [
        .details: AnyFetchConfig(
            FetchConfig(priority: 0) { [repo, mediaIdentifier] in
                try await repo.fetchMedia(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.media = result
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

    private func setupSectionsContext() {
        if mediaIdentifier.type != .tvShow {
            sectionsContext[.seasons] = .loaded(isEmpty: true)
        }
    }

    init(mediaID: Int, mediaType: MediaType) {
        self.mediaIdentifier = .init(id: mediaID, type: mediaType)
                
        self.seasons = .init(name: "Seasons")
        self.related = .init(
            name: "Related",
            dataProvider: RelatedMediasSectionDataProvider(identifier: mediaIdentifier)
        )
        self.collection = .init(name: "Collection")

        setupSectionsContext()
    }
    
    convenience init(media: Media) {
        self.init(mediaID: media.id, mediaType: media.mediaType)
        self.media = media
    }
}
