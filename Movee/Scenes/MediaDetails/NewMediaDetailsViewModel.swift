//
//  NewMediaDetailsViewModel.swift
//  Movee
//
//  Created by Oleh on 19.10.2025.
//

import Foundation

enum MediaDetailsSection: CaseIterable {
    case /*initial,*/ details, seasons, watchlist, credits, related, reviews, videos, collection
}


@MainActor
final class NewMediaDetailsViewModel: SectionFetchable, ObservableObject {
    private let repo: MediaDetailsRepositoryProtocol = MediaDetailsRepository()
    
    var sectionsContext = SectionsLoadingContext<MediaDetailsSection>()
    
    private(set) lazy var fetchConfigs: [MediaDetailsSection: AnyFetchConfig] = [
        // TODO: add dependent section
        .details: AnyFetchConfig(
            FetchConfig { [repo, mediaIdentifier] in
                try await repo.fetchMedia(mediaIdentifier)
            } onSuccess: { [weak self] result in
                self?.media = result
                self?.seasons = result.seasons
                self?.fetch(.collection)
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
            }
        )
    ]
    
    private var mediaIdentifier: MediaIdentifier

    @Published var media: Media?

    @Published var credits: [MediaPerson]? // done
    @Published var related: [Media]? // done
    @Published var reviews: [Review]? // done
    @Published var seasons: [Season]? // done
    @Published var videos: [Video]? // done
    @Published var collection: [Media]? // done
    
    func fetchInitialData() {
        Task {
            for section in MediaDetailsSection.allCases {
                try await fetchAsync(section)
            }
            try await fetchAsync(.collection)
        }
    }
    
    init(media: Media) {
        self.media = media
        self.mediaIdentifier = .init(id: media.id, type: media.mediaType)
        //self.sectionsContext[.initial] = .loaded(isEmpty: false)
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        self.mediaIdentifier = .init(id: mediaID, type: mediaType)
    }
}

import SwiftUI

struct NewMediaDetailsView: View {
    @StateObject var viewModel: NewMediaDetailsViewModel
    
    @State private var isScrolledDown: Bool = false
    @State private var headerSize: CGSize = .zero
    
    private var context: SectionsLoadingContext<MediaDetailsSection> {
        viewModel.sectionsContext
    }
    // TODO: make context configurable extension for .hideWhen and .isLoading; using just: .section(.related, context: context)
    var body: some View {
        if let media = viewModel.media {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    BackdropStrechyHeaderView(backdropURL: media.backdropURL)
                        .aspectRatio(4/3, contentMode: .fit)
                        .padding(.bottom, 80)
                        .overlay(alignment: .bottom) {
                            // TODO: decouple views from concrete DataModels
                            MediaDetailedInfoView(media: media)
                        }
                        .saveSize(in: $headerSize)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            MediaTaglineView(
                                tagline: viewModel.media?.tagline,
                                isLoading: context[.details].isLoading
                            )
                            Text(media.overview)
                                .textStyle(.mediumText)
                        }
                        
                        MediaVideosCarouselView(videos: viewModel.videos ?? [])
                            .hideWhen(context[.videos].isEmpty)
                        
//                        MediasSectionView(
//                            section: .init(title: "Seasons"),
//                            items: viewModel.seasonModels,
//                            errorMessage: nil,
//                            retry: { viewModel.fetchRelated() }
//                        ).hideWhen(
//                            viewModel.media?.mediaType != .tvShow ||
//                            viewModel.state.isEmpty(.seasons)
//                        )
                        
                        PersonsSectionView(persons: viewModel.credits)
                            .hideWhen(context[.credits].isEmpty)
                        
                        MediasSectionView(
                            section: MediasSection(title: ""),
                            medias: viewModel.related,
                            errorMessage: nil,
                            retry: { viewModel.fetch(.related) }
                        )
                        .hideWhen(context[.related].isEmpty)
                        
//                        if case .movie(let extra) = viewModel.media?.extra {
//                            MediaCollectionsCarouselView(collections: [extra.belongsToCollection].compactMap({ $0 }))
//                                .hideWhen(extra.belongsToCollection == nil)
//                        }
                        
                        Text("Facts")
                            .textStyle(.sectionTitle)
                        MediaFactsView(facts: media.facts)
                        
                        //if let collectionSection = viewModel.collectionSection {
                            MediasSectionView(
                                section: MediasSection(title: ""),
                                medias: viewModel.collection,
                                errorMessage: nil,
                                retry: { viewModel.fetch(.collection) }
                            )
                            .hideWhen(context[.collection].isEmpty)
                        //}

                        Group {
                            Text("Reviews")
                                .textStyle(.sectionTitle)
                            MediaReviewsCarouselView(reviews: viewModel.reviews ?? [])
                        }
                        .hideWhen(context[.reviews].isLoading || context[.reviews].isEmpty)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onFirstAppear {
                viewModel.fetchInitialData()
            }
            .onScrollGeometryChange(for: CGFloat.self, of: \.contentOffset.y) { _, newValue in
                isScrolledDown = newValue >= 1
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    if let isInWatchlist = viewModel.isInWatchlist {
//                        Button {
//                            viewModel.toggleWatchlist()
//                        } label: {
//                            Image(systemName: isInWatchlist ? "bookmark.slash" : "bookmark")
//                        }
//                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isScrolledDown ? media.title : "")
            .ignoresSafeArea(edges: .top)
        } else {
            VStack {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            }
        }
    }
    
    init(media: Media) {
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(media: media))
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(mediaID: mediaID, mediaType: mediaType))
    }
}
