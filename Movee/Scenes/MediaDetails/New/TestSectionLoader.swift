//
//  TestSectionLoader.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import Foundation
import Observation
import SwiftUI

// MARK: - Test ViewModel

@MainActor @Observable
final class TestMediaDetailsViewModel {
    private let repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository()
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
    
    init(mediaID: Int, mediaType: MediaType) {
        let mediaIdentifier = MediaIdentifier(id: mediaID, type: mediaType)
        self.mediaIdentifier = mediaIdentifier

        self.related = .init(
            name: "Related",
            dataProvider: TypedMediasListDataProvider.related(mediaIdentifier)
        )
        
        self.loader = SectionLoader(
            sections: Section.allCases,
            maxConcurrent: 3
        )
        self.loader.setConfigs([
            .details: .init(
                priority: 0,
                fetch: { [repo, mediaIdentifier] in
                    try await repo.fetchMedia(mediaIdentifier)
                },
                update: { [weak self] media in
                    self?.media = media
                    self?.loadWatchlistStatus()
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
        ])

        setupSectionsContext()
    }

    convenience init(media: Media) {
        self.init(mediaID: media.id, mediaType: media.mediaType)
        self.media = media
        loadWatchlistStatus()
    }

    private func setupSectionsContext() {
        if mediaIdentifier.type != .tvShow {
            loader.updateLoadState(for: .seasons, .loaded(isEmpty: true))
        }
    }
}

// MARK: - Watchlist Management

extension TestMediaDetailsViewModel: MediaDetailsWatchlistManager {
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

// MARK: - Helper Extension for AnyFetchConfig
//@MainActor
//extension AnyFetchConfig {
//    static func make<T>(
//        priority: Int = .max,
//        fetch: @escaping () async throws -> T,
//        update: @escaping @MainActor (T) -> Void
//    ) -> AnyFetchConfig {
//        AnyFetchConfig(FetchConfig(
//            priority: priority,
//            fetcher: fetch,
//            onSuccess: update
//        ))
//    }
//}


struct TestMediaDetailsView: View {
    @State private var viewModel: TestMediaDetailsViewModel
    @State private var isHeaderVisible: Bool = true
    
    private var navigationTitle: String {
        isHeaderVisible ? "" : viewModel.media?.title ?? ""
    }
            
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                setupStretchyHeader()
                LazyVStack(alignment: .leading, spacing: 16) {
                    setupDetailsSection()
                    setupVideosSection()
                    setupSeasonsSection()
                    setupCastAndCrewSection()
                    setupRelatedSection()
                    setupFactsSection()
                    setupCollectionSection()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .onFirstAppear {
            Task { await viewModel.loader.fetchInitialData() }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                WatchlistButton(watchlistManager: viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(navigationTitle)
        .ignoresSafeArea(edges: .top)
    }
    
    init(media: Media) {
        viewModel = TestMediaDetailsViewModel(media: media)
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        viewModel = TestMediaDetailsViewModel(mediaID: mediaID, mediaType: mediaType)
    }
}

private extension TestMediaDetailsView {
    @ViewBuilder
    func setupStretchyHeader() -> some View {
        BackdropStretchyHeaderView(backdropURL: viewModel.media?.backdropURL)
            .aspectRatio(4/3, contentMode: .fit)
            .padding(.bottom, 80)
            .overlay(alignment: .bottom) {
                MediaDetailedInfoView(media: viewModel.media ?? .placeholder)
                    .loading(viewModel.media == nil)
                    .onScrollVisibilityChange { isVisible in
                        isHeaderVisible = isVisible
                    }
            }
    }

    @ViewBuilder
    func setupDetailsSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            NewMediaTaglineView(tagline: viewModel.media?.tagline)
                .loading(viewModel.loader.loadState(for: .details).isAwaitingData)
            DescriptionView(text: viewModel.media?.overview)
                .loading(viewModel.media == nil)
        }
    }
    
    @ViewBuilder
    func setupVideosSection() -> some View {
        SectionView.trailers(viewModel.videos)
            .loadingState(viewModel.loader, section: .videos)
    }

    @ViewBuilder
    func setupReviewsSection() -> some View {
        SectionView.reviews(viewModel.reviews)
            .loadingState(viewModel.loader, section: .reviews)
    }
    
    @ViewBuilder
    func setupSeasonsSection() -> some View {
        SectionView.seasons(
            viewModel.seasons.items,
            media: viewModel.media,
            section: viewModel.seasons.section
        ).loadingState(viewModel.loader, section: .seasons)
    }
    
    @ViewBuilder
    func setupCastAndCrewSection() -> some View {
        SectionView.castAndCrew(viewModel.credits)
            .loadingState(viewModel.loader, section: .credits)
    }
    
    @ViewBuilder
    func setupRelatedSection() -> some View {
        SectionView.medias(
            viewModel.related.items,
            section: viewModel.related.section)
        .loadingState(viewModel.loader, section: .related)
    }
    
    @ViewBuilder
    func setupFactsSection() -> some View {
        if let facts = viewModel.media?.facts {
            SectionHeaderView(title: "Facts")
            MediaFactsView(facts: facts)
        }
    }
    
    @ViewBuilder
    func setupCollectionSection() -> some View {
        SectionView.medias(viewModel.collection.items,
                           section: viewModel.collection.section
        ).loadingState(viewModel.loader, section: .collection)
    }
}


//@Observable
//class SectionLoader<SectionType: Hashable> {
//    private let configs: [SectionType: AnyFetchConfig]
//    private let sections: [SectionType]
//    private let maxConcurrent: Int
//
//    private var currentTasks: [SectionType: Task<Void, Never>] = [:]
//
//    private(set) var loadStates: [SectionType: AsyncLoadingState] = [:]
//
//    init(
//        sections: [SectionType],
//        configs: [SectionType: AnyFetchConfig],
//        maxConcurrent: Int = 3
//    ) {
//        self.sections = sections
//        self.configs = configs
//        self.maxConcurrent = maxConcurrent
//    }
//
//    func loadState(for section: SectionType) -> AsyncLoadingState {
//        loadStates[section] ?? .idle
//    }
//
//    @MainActor
//    func updateLoadState(for section: SectionType, _ state: AsyncLoadingState) {
//        loadStates[section] = state
//    }
//
//    @MainActor
//    func fetchInitialData() {
//        Task {
//            let grouped = Dictionary(grouping: sections) { section in
//                configs[section]?.priority ?? .max
//            }
//
//            for priority in grouped.keys.sorted() {
//                let sectionsAtPriority = grouped[priority] ?? []
//
//                for chunk in sectionsAtPriority.chunked(into: maxConcurrent) {
//                    await withTaskGroup { group in
//                        for section in chunk {
//                            group.addTask {
//                                await self.fetchAsync(section)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    @MainActor
//    func fetch(_ section: SectionType) {
//        guard let config = configs[section] else {
//            let error = FetchError.noConfigurationFound(section: String(describing: section))
//            loadStates[section] = .error(error)
//            return
//        }
//
//        guard !(loadStates[section]?.isLoading ?? false) else { return }
//
//        // Cancel existing task if any
//        currentTasks[section]?.cancel()
//
//        let task = Task { @MainActor [weak self] in
//            guard let self else { return }
//
//            self.loadStates[section] = .loading
//
//            do {
//                let isEmpty = try await config.fetch()
//                guard !Task.isCancelled else { return }
//                self.loadStates[section] = .loaded(isEmpty: isEmpty)
//            } catch {
//                guard !Task.isCancelled else { return }
//                self.loadStates[section] = .error(error)
//            }
//
//            self.currentTasks[section] = nil
//        }
//
//        currentTasks[section] = task
//    }
//
//    @MainActor
//    func fetchAsync(_ section: SectionType) async {
//        guard let config = configs[section] else {
//            let error = FetchError.noConfigurationFound(section: String(describing: section))
//            loadStates[section] = .error(error)
//            return
//        }
//
//        guard !(loadStates[section]?.isLoading ?? false), !(loadStates[section]?.isLoaded ?? false) else { return }
//
//        loadStates[section] = .loading
//
//        do {
//            let isEmpty = try await config.fetch()
//            guard !Task.isCancelled else { return }
//            loadStates[section] = .loaded(isEmpty: isEmpty)
//        } catch {
//            guard !Task.isCancelled else { return }
//            loadStates[section] = .error(error)
//        }
//    }
//
//    @MainActor
//    func refetchFailed() {
//        let failedSections = sections.filter { loadStates[$0]?.error != nil }
//
//        Task {
//            await withTaskGroup { group in
//                for section in failedSections {
//                    group.addTask {
//                        await self.fetchAsync(section)
//                    }
//                }
//            }
//        }
//    }
//
//    func cancelAll() {
//        currentTasks.values.forEach { $0.cancel() }
//        currentTasks.removeAll()
//    }
//
//    deinit {
//        cancelAll()
//    }
//}
//
//extension SectionLoader {
//    var hasFailedSections: Bool {
//        loadStates.values.contains { $0.error != nil }
//    }
//
//    var isLoadingAnySections: Bool {
//        loadStates.values.contains { $0.isLoading }
//    }
//
//    var allSectionsLoaded: Bool {
//        sections.allSatisfy { loadStates[$0]?.isLoaded ?? false }
//    }
//}

