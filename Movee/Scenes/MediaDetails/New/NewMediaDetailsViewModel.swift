//
//  NewMediaDetailsViewModel.swift
//  Movee
//
//  Created by Oleh on 19.10.2025.
//

import Foundation

enum MediaDetailsSection: CaseIterable {
    case details, seasons, videos, /*watchlist,*/ credits, related, reviews, collection
}

struct MediasCollection {
    let name: String
    let medias: [Media]
}

struct SectionData<T> {
    let section: NewMediasSection
    var data: T
}

@MainActor
final class NewMediaDetailsViewModel: SectionFetchable, ObservableObject {
    private let repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository()
    
    private var mediaIdentifier: MediaIdentifier

    @Published var media: Media?

    @Published var credits: [MediaPerson]?
    @Published var related: [Media]?
    @Published var reviews: [Review]?
    @Published var seasons: [Season]?
    @Published var videos: [Video]?
    @Published var collection: MediasCollection?
    
    private(set) lazy var mediaSections: [MediaDetailsSection: NewMediasSection] = [
        .seasons: .init(title: "Seasons"),
        .credits: .init(title: "Related", dataProvider: RelatedMediasSectionDataProvider(identifier: mediaIdentifier))
    ]
    
    @Published var sectionsContext = SectionsLoadingContext<MediaDetailsSection>()

    private(set) lazy var fetchConfigs: [MediaDetailsSection: AnyFetchConfig] = [
        .details: AnyFetchConfig(
            FetchConfig { [repo, mediaIdentifier] in
                try await repo.fetchMedia(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.media = result
            }
        ),
        .seasons: AnyFetchConfig(
            FetchConfig { [unowned self] in
                media?.seasons
            } onSuccess: { [weak self] result in
                self?.seasons = result
            }
        ),
        .related: AnyFetchConfig(
            FetchConfig { [repo, mediaIdentifier] in
                try await repo.fetchRelated(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.related = result
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
                self?.collection = result
            } isEmpty: { result in
                result?.medias.isEmpty ?? true
            }
        )
    ]
        
    func fetchInitialData() {
        Task {
            for section in MediaDetailsSection.allCases {
                await fetchAsync(section)
            }
        }
    }
    
    private func setupSectionsContext() {
        if mediaIdentifier.type != .tvShow {
            sectionsContext[.seasons] = .loaded(isEmpty: true)
        }
    }

    init(media: Media) {
        self.media = media
        self.mediaIdentifier = .init(id: media.id, type: media.mediaType)
        setupSectionsContext()
    }

    init(mediaID: Int, mediaType: MediaType) {
        self.mediaIdentifier = .init(id: mediaID, type: mediaType)
        setupSectionsContext()
    }
}
