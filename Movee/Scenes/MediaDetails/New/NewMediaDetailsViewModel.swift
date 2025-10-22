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

    var sectionsContext = SectionsLoadingContext<MediaDetailsSection>()

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

import SwiftUI

protocol LoadableView: View {
    associatedtype LoadingContent: View
    @ViewBuilder func loadingView() -> LoadingContent
}

protocol FailableView: View {
    associatedtype ErrorContent: View
    @ViewBuilder func errorView(error: Error, retry: (() -> Void)?) -> ErrorContent
}

struct LoadingModifier<LoadingContent: View>: ViewModifier {
    let isLoading: Bool
    let loadingContent: () -> LoadingContent

    func body(content: Content) -> some View {
        if isLoading {
            loadingContent()
        } else {
            content
        }
    }
}

struct ErrorModifier<ErrorContent: View>: ViewModifier {
    let error: Error?
    let retry: () -> Void
    let errorContent: (Error) -> ErrorContent

    func body(content: Content) -> some View {
        if let error {
            errorContent(error)
        } else {
            content
        }
    }
}

extension LoadableView {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading) {
            self.loadingView()
        })
    }
}

extension FailableView {
    func error(_ error: Error?, retry: @escaping () -> Void) -> some View
{
        modifier(ErrorModifier(error: error, retry: retry) { error in
            self.errorView(error: error, retry: retry)
        })
    }
}

struct NewMediasSection {
    typealias PublisherBuilder = (Int) -> AnyPublisher<PaginatedResponse<Media>, Error>
    
    struct Placeholder {
        let title: String
        let subtitle: String?
    }
    
    let title: String
    let fullTitle: String?
    let placeholder: Placeholder?
    let publisherBuilder: PublisherBuilder?
    
    init(title: String, fullTitle: String? = nil, placeholder: Placeholder? = nil, publisherBuilder: PublisherBuilder? = nil) {
        self.title = title
        self.fullTitle = fullTitle
        self.placeholder = placeholder
        self.publisherBuilder = publisherBuilder
    }
}

struct NewMediasSectionView: View, LoadableView, FailableView {
    let section: MediasSection
    let medias: [MediaUIModel]?
    //let errorMessage: String?
    //var retry: (() -> Void)?
    var horizontalPadding: CGFloat

//    enum ViewState {
//        case loading, loaded, error
//    }
    
//    var isLoading: Bool {
//        medias == nil
//    }

//    var viewState: ViewState {
//        if isLoading {
//            return .loading
//        } else if let errorMessage = errorMessage, !errorMessage.isEmpty {
//            return .error
//        } else {
//            return .loaded
//        }
//    }
    
    func loadingView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top) {
                ForEach(0..<5, id: \.self) { _ in
                    MediaPosterView(.placeholder)
                        .redacted(reason: .placeholder)
                        .shimmering()
                }
            }
            .padding(.horizontal, horizontalPadding)
        }.padding(.horizontal, -horizontalPadding)
    }
    
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        VStack(spacing: 10) {
            Text("Error: \(error.localizedDescription)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            Button("Retry", action: retry ?? {})
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
        
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(
                title: section.title,
                isButtonHidden: false) {
                    AnyView(MediasListView(section: section))
                }
            //Group {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(medias ?? []) { media in
                        NavigationLink {
                            switch media.object {
                            case .media(let media):
                                NewMediaDetailsView(media: media)
                            case .season(let season, let media):
                                SeasonDetailsView(tvShowID: media.id, season: season)
                            default:
                                EmptyView()
                            }
                        } label: {
                            MediaPosterView(media)
                        }
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }.padding(.horizontal, -horizontalPadding)
            //}.animation(.easeOut, value: viewState)
        }
    }
    
    // MARK: - Designated Initializer

    init(
        section: MediasSection,
        items: [MediaUIModel]?,
        horizontalPadding: CGFloat = 20
    ) {
        self.section = section
        self.medias = items
        self.horizontalPadding = horizontalPadding
    }
}

// MARK: - Convenience Initializers
extension NewMediasSectionView {
    init(
        section: MediasSection,
        medias: [Media]?,
        horizontalPadding: CGFloat = 20
    ) {
        self.init(
            section: section,
            items: medias?.map { .init(media: $0) },
            horizontalPadding: horizontalPadding
        )
    }

    init(
        section: MediasSection,
        seasons: [Season]?,
        media: Media?,
        horizontalPadding: CGFloat = 20
    ) {
        let items: [MediaUIModel]? = {
            guard let media = media else { return nil }
            return seasons?.map { .init(season: $0, media: media) }
        }()

        self.init(
            section: section,
            items: items,
            horizontalPadding: horizontalPadding
        )
    }
}


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
                            // TODO: global isLoading?? (LoadableView protocol)
                            MediaTaglineView(
                                tagline: viewModel.media?.tagline,
                                isLoading: context[.details].isLoading
                            )
                            Text(media.overview)
                                .textStyle(.mediumText)
                        }
                        
                        MediaVideosCarouselView(videos: viewModel.videos ?? [])
                            .hideWhen(context[.videos].isEmpty)
                        
                        MediasSectionView(
                            section: .init(title: "Seasons"),
                            seasons: viewModel.seasons,
                            media: viewModel.media,
                            errorMessage: nil,
                            retry: { viewModel.fetch(.details) }
                        ).hideWhen(
                            context[.seasons].isEmpty
                        )
                        
                        PersonsSectionView(persons: viewModel.credits)
                            .hideWhen(context[.credits].isEmpty)
                        
                        MediasSectionView(
                            section: MediasSection(title: ""),
                            medias: viewModel.related,
                            errorMessage: nil,
                            retry: { viewModel.fetch(.related) }
                        )
                        .hideWhen(context[.related].isEmpty)
                        
                        
                        Text("Facts")
                            .textStyle(.sectionTitle)
                        MediaFactsView(facts: media.facts)
                        
                        MediasSectionView(
                            section: MediasSection(title: viewModel.collection?.name ?? ""),
                            medias: viewModel.collection?.medias,
                            errorMessage: nil,
                            retry: { viewModel.fetch(.collection) }
                        )
                        .hideWhen(context[.collection].isEmpty)

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
