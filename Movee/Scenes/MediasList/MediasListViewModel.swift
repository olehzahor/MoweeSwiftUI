//
//  MediasListViewModel.swift
//  Movee
//
//  Created by user on 4/8/25.
//

import Combine
import Foundation

protocol MediasListDataProvider {
    func fetch(page: Int) async throws -> PaginatedResponse<Media>
}

struct RelatedMediasSectionDataProvider: MediasListDataProvider {
    private let networkClient = NetworkClient2(
        interceptors: [
            TMDBInterceptor(),
            LoggingInterceptor(logger: Logger.shared)
        ],
        decoder: TMDBJSONDecoder()
    )

    let identifier: MediaIdentifier
    
    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        switch identifier.type {
        case .movie:
            let request = TMDB.MovieRecommendations(movieID: identifier.id, page: page)
            return try await networkClient.request(request).map { Media(movie: $0) }
        case .tvShow:
            let request = TMDB.TVShowRecommendations(tvShowID: identifier.id, page: page)
            return try await networkClient.request(request).map { Media(tvShow: $0) }
        }
    }
}

struct NewMediasSection {
    struct Placeholder {
        let title: String
        let subtitle: String?
    }
    
    let title: String
    let fullTitle: String?
    let placeholder: Placeholder?
    let dataProvider: MediasListDataProvider?
    
    init(title: String, fullTitle: String? = nil, placeholder: Placeholder? = nil, dataProvider: MediasListDataProvider? = nil) {
        self.title = title
        self.fullTitle = fullTitle
        self.placeholder = placeholder
        self.dataProvider = dataProvider
    }
}

@MainActor
class NewMediasListViewModel: ObservableObject {
    @Published var medias: [Media] = []
    @Published var section: NewMediasSection
    @Published var isLoaded: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    @Published var isLoadingPage: Bool = false
    
    var hasMorePages: Bool {
        return currentPage <= totalPages
    }

    func fetchMedias() {
        guard !isLoadingPage, hasMorePages else { return }
        isLoadingPage = true
        
        Task {
            guard let response = try await section.dataProvider?.fetch(page: currentPage) else { return }
            if response.page == 1 { medias = [] }
            medias.append(contentsOf: response.results)
            totalPages = response.total_pages
            currentPage += 1
            isLoaded = true
            isLoadingPage = false
        }
//        
//        section.publisherBuilder?(currentPage)
//            .sink { [unowned self] completion in
//                isLoadingPage = false
//                if case .failure(let error) = completion {
//                    print("Error fetching medias: \(error)")
//                }
//            } receiveValue: { [unowned self] response in
//                if response.page == 1 { medias = [] }
//                medias.append(contentsOf: response.results)
//                totalPages = response.total_pages
//                currentPage += 1
//                isLoaded = true
//            }
//            .store(in: &cancellables)
    }
    
    func isLastLoaded(media: Media) -> Bool {
        media.id == medias.last?.id
    }
    
    init(section: NewMediasSection) {
        self.section = section
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}


class MediasListViewModel: ObservableObject {
    @Published var medias: [Media] = []
    @Published var section: MediasSection
    @Published var isLoaded: Bool = false

    private var cancellables = Set<AnyCancellable>()
    
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    @Published var isLoadingPage: Bool = false
    
    var hasMorePages: Bool {
        return currentPage <= totalPages
    }

    func fetchMedias() {
        guard !isLoadingPage, hasMorePages else { return }
        isLoadingPage = true
        
        section.publisherBuilder?(currentPage)
            .sink { [unowned self] completion in
                isLoadingPage = false
                if case .failure(let error) = completion {
                    print("Error fetching medias: \(error)")
                }
            } receiveValue: { [unowned self] response in
                if response.page == 1 { medias = [] }
                medias.append(contentsOf: response.results)
                totalPages = response.total_pages
                currentPage += 1
                isLoaded = true
            }
            .store(in: &cancellables)
    }
    
    func isLastLoaded(media: Media) -> Bool {
        media.id == medias.last?.id
    }
    
    init(section: MediasSection) {
        self.section = section
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
