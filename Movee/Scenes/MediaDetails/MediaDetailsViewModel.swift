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
        case initial, details, watchlist, credits, related, reviews
    }
}

final class MediaDetailsViewModel: ObservableObject {
    private var mediaID: Int
    @Published var media: Media? {
        didSet { updateWatchlistStatus() }
    }
    
    @Published var credits: [MediaPerson]?
    @Published var related: [Media]?
    @Published var reviews: [Review]?
    
    @Published var isInWatchlist: Bool? = nil
    @Published var state = ViewLoadingState<Section>()
    
    var isLoadedDetails: Bool {
        state.isLoaded(.details)
    }
    
    private var cancellables = Set<AnyCancellable>()

    private(set) lazy var relatedSection: MediasSection = {
        MediasSection(title: "Related", fullTitle: "\(media?.title ?? ""): related") { [unowned self] page in
            TMDBAPIClient.shared.fetchMovieRelated(movieID: mediaID, page: page)
                .map { $0.map { Media(movie: $0) } }
                .eraseToAnyPublisher()
        }
    }()

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
        guard let media else { return }
        state.setLoading(.details)
        switch media.mediaType {
        case .movie:
            subscribeTo(
                publisher: TMDBAPIClient.shared.fetchMovieDetails(movieID: media.id),
                transform: { Media(movie: $0) }
            )
        case .tvShow:
            subscribeTo(
                publisher: TMDBAPIClient.shared.fetchTVShowDetails(tvShowID: media.id),
                transform: { Media(tvShow: $0) }
            )
        }
    }
    
    func fetchCredits() {
        guard let mediaID = media?.id else { return }
        state.setLoading(.credits)
        TMDBAPIClient.shared.fetchMovieCredits(movieID: mediaID).sink { [unowned self] completion in
            if case let .failure(error) = completion {
                self.state.setError(.credits, error)
            }
        } receiveValue: { [unowned self] response in
            Task { await handleCreditsResponse(response) }
        }.store(in: &cancellables)
    }
    
    func fetchRelated() {
        relatedSection.publisherBuilder(1).sink { completion in
            if case let .failure(error) = completion {
                self.state.setError(.related, error)
            }
        } receiveValue: { [unowned self] response in
            related = response.results
            state.setLoaded(.related, isEmpty: response.results.isEmpty)
        }.store(in: &cancellables)
    }
    
    func fetchReviews() {
        TMDBAPIClient.shared.fetchMovieReviews(movieID: media!.id) .sink { completion in
            if case let .failure(error) = completion {
                self.state.setError(.reviews, error)
            }
        } receiveValue: { [unowned self] response in
            self.reviews = response.results
            self.state.setLoaded(.reviews, isEmpty: response.results.isEmpty)
        }.store(in: &cancellables)
    }
        
    func fetchInitialData() {
        fetchDetails()
        fetchCredits()
        fetchRelated()
        fetchReviews()
    }
        
    init(media: Media) {
        self.media = media
        self.mediaID = media.id
        self.state.setLoaded(.initial, isEmpty: false)
        fetchDetails()
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        self.mediaID = mediaID
        switch mediaType {
        case .movie:
            subscribeTo(
                publisher: TMDBAPIClient.shared.fetchMovieDetails(movieID: mediaID),
                transform: { Media(movie: $0) }
            )
        case .tvShow:
            subscribeTo(
                publisher: TMDBAPIClient.shared.fetchTVShowDetails(tvShowID: mediaID),
                transform: { Media(tvShow: $0) }
            )
        }
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
                self?.state.setLoaded(.details, isEmpty: false)
            }
            .store(in: &cancellables)
    }
}
