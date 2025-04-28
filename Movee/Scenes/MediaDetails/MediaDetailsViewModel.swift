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
        case credits, related, reviews
    }
}

final class MediaDetailsViewModel: ObservableObject {
    @Published var media: Media? {
        didSet { updateWatchlistStatus() }
    }
    
    @Published var credits: [MediaPerson]?
    @Published var related: [Media]?
    @Published var reviews: [Review]?
    
    @Published var isInWatchlist: Bool? = nil
    
    private var cancellables = Set<AnyCancellable>()

    private(set) lazy var relatedSection: MediasSection? = { () -> MediasSection? in
        guard let mediaID = media?.id else { return nil }
        return MediasSection(title: "Related", fullTitle: "\(media?.title ?? ""): related") { page in
            TMDBAPIClient.shared.fetchMovieRelated(movieID: mediaID, page: page)
                .map { $0.map { Media(movie: $0) } }
                .eraseToAnyPublisher()
        }
    }()

    private func updateWatchlistStatus() {
        guard let media else { return }
        Task {
            let isInWatchlist = await WatchlistManager.shared.isInWatchlist(media)
            await MainActor.run {
                self.isInWatchlist = isInWatchlist
            }
        }
    }
    
    func toggleWatchlist() {
        guard let media else { return }
        Task {
            await WatchlistManager.shared.toggleWatchlist(media)
            updateWatchlistStatus()
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
        }
    }
    
    func fetchCredits() {
        guard let mediaID = media?.id else { return }
        TMDBAPIClient.shared.fetchMovieCredits(movieID: mediaID).sink { completion in
            
        } receiveValue: { [unowned self] response in
            Task { await handleCreditsResponse(response) }
        }.store(in: &cancellables)
    }
    
    func fetchRelated() {
        guard let relatedSection else { return }
        relatedSection.publisherBuilder(1).sink { completion in
            
        } receiveValue: { [unowned self] response in
            related = response.results
        }.store(in: &cancellables)
    }
    
    func fetchReviews() {
        TMDBAPIClient.shared.fetchMovieReviews(movieID: media!.id) .sink { completion in
            
        } receiveValue: { [unowned self] response in
            self.reviews = response.results
        }.store(in: &cancellables)
    }
    
    func fetchInitialData() {
        fetchCredits()
        fetchRelated()
        fetchReviews()
    }
    
    private func isEmpty<T>(_ array: [T]?) -> Bool {
        (array ?? []).isEmpty
    }

    private func isNotNilAndEmpty<T>(_ array: [T]?) -> Bool {
        guard let array else { return false }
        return array.isEmpty
    }
    
    func isLoading(_ section: Section) -> Bool {
        switch section {
        case .credits:
            isEmpty(credits)
        case .related:
            isEmpty(related)
        case .reviews:
            isEmpty(reviews)
        }
    }
    
    func isReadyForDisplay(_ section: Section) -> Bool {
        switch section {
        case .credits:
            isNotNilAndEmpty(credits)
        case .related:
            isNotNilAndEmpty(related)
        case .reviews:
            isNotNilAndEmpty(reviews)
        }
    }
    
    init(media: Media) {
        self.media = media
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
    
    init(mediaID: Int, mediaType: MediaType) {
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
                }
            } receiveValue: { [weak self] value in
                self?.media = transform(value)
            }
            .store(in: &cancellables)
    }
}
