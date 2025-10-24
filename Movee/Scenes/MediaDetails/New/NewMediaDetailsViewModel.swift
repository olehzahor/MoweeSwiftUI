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
    var medias: [Media]
}

extension NewMediaDetailsViewModel {
    struct MediasSection {
        var name: String
        var fullName: String?
        var placeholder: NewMediasSection.Placeholder?
        var dataProvider: (any MediasListDataProvider)?
        
        var medias: [Media]
        
        var section: NewMediasSection { .init(
            title: name,
            fullTitle: fullName,
            placeholder: placeholder,
            dataProvider: dataProvider)
        }
        
        mutating func update(with collection: MediasCollection) {
            self.name = collection.name
            self.medias = collection.medias
        }
    }
}


@MainActor
final class NewMediaDetailsViewModel: SectionFetchable, FailedSectionsReloadable, ObservableObject {
    private let repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository()
    
    private var mediaIdentifier: MediaIdentifier

    @Published var media: Media?

    @Published var credits: [MediaPerson]?
    @Published var related: [Media]?
    @Published var reviews: [Review]?
    @Published var seasons: [Season]?
    @Published var videos: [Video]?
    @Published var collection: MediasCollection?
    
    @Published var recommended: MediasSection
    @Published var collection2: MediasSection

        
    var mediaSections: [MediaDetailsSection: NewMediasSection] {[
        .seasons: .init(title: "Seasons"),
        .related: .init(title: "Related", dataProvider: RelatedMediasSectionDataProvider(identifier: mediaIdentifier)),
        .collection: .init(title: collection?.name ?? "")
    ]}
    
    @Published var sectionsContext = AsyncLoadingContext<MediaDetailsSection>()

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
                self?.recommended.medias = result
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
                guard let result else { return }
                self?.collection2.update(with: result)
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

    init(mediaID: Int, mediaType: MediaType) {
        self.mediaIdentifier = .init(id: mediaID, type: mediaType)
        
        self.recommended = .init(
            name: "Recommended",
            dataProvider: RelatedMediasSectionDataProvider(identifier: mediaIdentifier),
            medias: [])
        
        self.collection2 = .init(
            name: "Collection",
            medias: [])

        setupSectionsContext()
    }
    
    convenience init(media: Media) {
        self.init(mediaID: media.id, mediaType: media.mediaType)
        self.media = media
    }
}
