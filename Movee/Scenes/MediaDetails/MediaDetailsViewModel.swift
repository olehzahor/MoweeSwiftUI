//
//  MediaDetailsViewModel.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI
import Combine

//TODO: create template or even base class for ViewModels with wrappers for combine calls, errors handling and cancellables management

extension MediaDetailsViewModel {
    enum Section {
        case initial, details, seasons, watchlist, credits, related, reviews, videos, collection
    }
}

final class MediaDetailsViewModel: ObservableObject {
    private var mediaIdentifier: MediaIdentifier
    
    @Published var media: Media? {
        didSet { updateWatchlistStatus() }
    }
    
    @Published var credits: [MediaPerson]?
    @Published var related: [Media]?
    @Published var reviews: [Review]?
    @Published var seasons: [Season]?
    @Published var videos: [Video]?
    @Published var collection: [Media]?
    
    var seasonModels: [MediaUIModel]? {
        guard let media, let seasons else { return nil }
        return seasons.compactMap { .init(season: $0, media: media) }
    }
    
    @Published var isInWatchlist: Bool? = nil
    @Published var state = ViewLoadingState<Section>()
    
    var isLoadedDetails: Bool {
        state.isLoaded(.details)
    }
    
    private var cancellables = Set<AnyCancellable>()

    private(set) lazy var relatedSection: MediasSection = {
        MediasSection(title: "Related", fullTitle: "\(media?.title ?? ""): related") { [unowned self] page in
            switch mediaIdentifier.type {
            case .movie:
                TMDBAPIClient.shared.fetchMovieRecommendations(movieID: mediaIdentifier.id, page: page)
                    .map { $0.map { Media(movie: $0) } }
                    .eraseToAnyPublisher()
            case .tvShow:
                TMDBAPIClient.shared.fetchTVShowRecommendations(tvShowID: mediaIdentifier.id, page: page)
                    .map { $0.map { Media(tvShow: $0) } }
                    .eraseToAnyPublisher()
            }
        }
    }()
    
    var collectionSection: MediasSection? {
        guard let media, case .movie(let extra) = media.extra,
              let collection = extra.belongsToCollection
        else { return nil }
        return .init(title: collection.name) { [unowned self] _ in
            self.$collection
                .compactMap { $0 }
                .map { .wrap($0) }
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }

    private func updateWatchlistStatus() {
        guard let media else { return }
        state.setLoading(.watchlist)
        Task {
            let isInWatchlist = await WatchlistManager.shared.isInWatchlist(media)
            await MainActor.run {
                state.setLoaded(.watchlist, isEmpty: false)
                self.isInWatchlist = isInWatchlist
            }
        }
    }
    
    func toggleWatchlist() {
        guard let media else { return }
        Task {
            await WatchlistManager.shared.toggleWatchlist(media)
            await MainActor.run { updateWatchlistStatus() }
        }
    }
        
    private func handleCreditsResponse(_ response: CreditsResponse) async {
        let cast = response.cast.map({ MediaPerson(castMember: $0) })
        let crew = response.crew.map({ MediaPerson(crewMember: $0) })
        var credits = cast + crew
        credits.sort { $0.order ?? .max <= $1.order ?? .max }
        if let index = credits.firstIndex(where: { $0.role == "Director" }) {
            credits.insert(credits.remove(at: index), at: 0)
        }
        await MainActor.run { [credits] in
            self.credits = credits
            self.state.setLoaded(.credits, isEmpty: credits.isEmpty)
        }
    }
    
    func fetchDetails() {
        state.setLoading(.details)
        state.setLoading(.seasons)
        switch mediaIdentifier.type {
        case .movie:
            subscribeTo(
                publisher: TMDBAPIClient.shared.fetchMovieDetails(movieID: mediaIdentifier.id),
                transform: { Media(movie: $0) }
            )
        case .tvShow:
            subscribeTo(
                publisher: TMDBAPIClient.shared.fetchTVShowDetails(tvShowID: mediaIdentifier.id),
                transform: { Media(tvShow: $0) }
            )
        }
    }
    
    func fetchCredits() {
        state.setLoading(.credits)
        
        let publisher = switch mediaIdentifier.type {
        case .movie:
            TMDBAPIClient.shared.fetchMovieCredits(movieID: mediaIdentifier.id)
        case .tvShow:
            TMDBAPIClient.shared.fetchTVShowCredits(tvShowID: mediaIdentifier.id)
        }
        
        publisher.sink { [unowned self] completion in
            if case let .failure(error) = completion {
                self.state.setError(.credits, error)
            }
        } receiveValue: { [unowned self] response in
            Task { await handleCreditsResponse(response) }
        }.store(in: &cancellables)
    }
    
    func fetchRelated() {
        relatedSection.publisherBuilder?(1).sink { completion in
            if case let .failure(error) = completion {
                self.state.setError(.related, error)
            }
        } receiveValue: { [unowned self] response in
            related = response.results
            state.setLoaded(.related, isEmpty: response.results.isEmpty)
        }.store(in: &cancellables)
    }
    
    private lazy var publishers: [Section: AnyPublisher] = [
        .credits: TMDBAPIClient.shared.fetchMovieReviews(movieID: mediaIdentifier.id)
    ]
    
    func fetchReviews() {
        state.setLoading(.reviews)

        let publisher = switch mediaIdentifier.type {
        case .movie:
            TMDBAPIClient.shared.fetchMovieReviews(movieID: mediaIdentifier.id)
        case .tvShow:
            TMDBAPIClient.shared.fetchTVShowReviews(tvShowID: mediaIdentifier.id)
        }

        publisher.sink { completion in
            if case let .failure(error) = completion {
                self.state.setError(.reviews, error)
            }
        } receiveValue: { [unowned self] response in
            self.reviews = response.results
            self.state.setLoaded(.reviews, isEmpty: response.results.isEmpty)
        }.store(in: &cancellables)
    }
    
    func fetchVideos() {
        state.setLoading(.videos)
        
        // Choose the right endpoint based on movie vs. TV show
        let publisher: AnyPublisher<VideoResponse, Error> = switch mediaIdentifier.type {
        case .movie:
            TMDBAPIClient.shared.fetchMovieVideos(movieID: mediaIdentifier.id)
        case .tvShow:
            TMDBAPIClient.shared.fetchTVShowVideos(tvShowID: mediaIdentifier.id)
        }
        
        publisher
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state.setError(.videos, error)
                }
            } receiveValue: { [weak self] response in
                let trailers = response.results.filter { $0.type == .trailer && ($0.official ?? false) }
                self?.videos = trailers
                self?.state.setLoaded(.videos, isEmpty: trailers.isEmpty)
            }
            .store(in: &cancellables)
    }
    
    func genericFetch() {
        
    }
    
    func fetchCollection() {
        guard let media, case .movie(let extra) = media.extra,
              let collection = extra.belongsToCollection
        else { return }
        
        state.setLoading(.collection)
        
        let publisher = TMDBAPIClient.shared.fetchCollection(collectionID: collection.id)

        publisher.sink { completion in
            if case let .failure(error) = completion {
                self.state.setError(.reviews, error)
            }
        } receiveValue: { [unowned self] response in
            self.collection = response.parts
                .map { .init(movie: $0) }
                .sorted { $0.releaseYear ?? 0 <= $1.releaseYear ?? 0 }
            self.state.setLoaded(.collection, isEmpty: response.parts.isEmpty)
        }.store(in: &cancellables)
    }
        
    func fetchInitialData() {
        fetchDetails()
        fetchCredits()
        fetchRelated()
        fetchReviews()
        fetchVideos()
    }
        
    init(media: Media) {
        self.media = media
        self.mediaIdentifier = .init(id: media.id, type: media.mediaType)
        self.state.setLoaded(.initial, isEmpty: false)
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        self.mediaIdentifier = .init(id: mediaID, type: mediaType)
    }
    
    private func subscribeTo<T>(publisher: AnyPublisher<T, Error>, transform: @escaping (T) -> Media) {
        publisher
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Error fetching media details: \(error)")
                    self?.state.setError(.details, error)
                }
            } receiveValue: { [weak self] value in
                self?.media = transform(value)
                
                switch self?.media?.extra {
                case .tvShow(let extra):
                    self?.seasons = extra.seasons
                default:
                    break
                }
                
                self?.state.setLoaded(.initial, isEmpty: false)
                self?.state.setLoaded(.details, isEmpty: false)
                self?.state.setLoaded(.seasons, isEmpty: self?.seasons?.isEmpty ?? true)
                
                self?.fetchCollection()
            }
            .store(in: &cancellables)
    }
}
