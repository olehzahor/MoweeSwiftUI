//
//  NewMediasListViewModel.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import Combine
import Foundation

//

extension PaginatedResponse: OffsetPaginationMetadata {
    var currentPage: Int {
        page
    }
    
    var totalPages: Int {
        total_pages
    }
    
    var resultsCount: Int {
        total_results
    }
}

protocol OffsetPaginationMetadata {
    var currentPage: Int { get }
    var totalPages: Int { get }
    var resultsCount: Int { get }
}

protocol PaginatedFetcher: AnyObject {
    //associatedtype Item: Decodable
    associatedtype Response
    associatedtype Pagination: PaginationContext
    
    //var items: [Item] { get set }
    
    var paginationContext: Pagination { get set }
    var loadingState: AsyncLoadingState { get set }
    
    func fetchData(_ context: Pagination) async throws -> Response
    // TODO: consider responsibility chain here
    func updatePaginationContext(_ response: Response)
    func handleFirstFetch(_ response: Response)
    func handlePageFetch(_ response: Response)
    func isResponseEmpty(_ response: Response) -> Bool
    
    //func fetch() async throws
    //func isLastItem(_ item: Item) -> Bool
}

protocol AutomaticPaginatedFetcher: PaginatedFetcher {
    associatedtype Item: Decodable&Identifiable
    var items: [Item] { get set }
}

extension AutomaticPaginatedFetcher where Pagination == OffsetPaginationContext, Response: OffsetPaginationMetadata {
    func updatePaginationContext(_ response: Response) {
        paginationContext.update(with: response)
    }
}

extension AutomaticPaginatedFetcher where Response == PaginatedResponse<Item> {
    func handleFirstFetch(_ response: Response) {
        items = response.results
    }
    
    func handlePageFetch(_ response: Response) {
        items += response.results
    }
    
    func isResponseEmpty(_ response: Response) -> Bool {
        response.results.isEmpty
    }
}

extension PaginatedFetcher {
    @MainActor
    func fetch() {
        guard paginationContext.hasMorePages, !loadingState.isLoading else { return }
        loadingState = .loading
        Task {
            do {
                let response = try await fetchData(paginationContext)
                guard !Task.isCancelled else { return }
                updatePaginationContext(response)
                if paginationContext.isOnFirstPage {
                    handleFirstFetch(response)
                } else {
                    handlePageFetch(response)
                }
                loadingState = .loaded(isEmpty: isResponseEmpty(response))
            } catch {
                loadingState = .error(error)
            }
        }
    }
}

//extension PaginatedFetcher where Item: Equatable {
//    func isLastItem(_ item: Item) -> Bool {
//        items.last == item
//    }
//}

enum MediasSectionError: String, LocalizedError {
    case noDataProvider = "No data provider has been provided for this section"
    
    var errorDescription: String? { rawValue }
}

@MainActor @Observable
class NewMediasListViewModel: @preconcurrency AutomaticPaginatedFetcher {
    
    let section: NewMediasSection

    var items: [Media] = []

    var paginationContext = OffsetPaginationContext()
    var loadingState = AsyncLoadingState.idle
    
    func fetchData(_ context: OffsetPaginationContext) async throws -> PaginatedResponse<Media> {
        guard let dataProvider = section.dataProvider else { throw MediasSectionError.noDataProvider }
        return try await dataProvider.fetch(page: context.currentPage)
    }
            
    init(section: NewMediasSection) {
        self.section = section
    }
}

protocol PaginationContext {
    var isOnFirstPage: Bool { get }
    var hasMorePages: Bool { get }
}

struct OffsetPaginationContext {
    private static let firstPage: Int = 1

    var currentPage: Int = Self.firstPage
    var totalPages: Int = Self.firstPage
    var resultsCount: Int = 0
    
    mutating func update(with metadata: OffsetPaginationMetadata) {
        currentPage = metadata.currentPage + 1
        totalPages = metadata.totalPages
        resultsCount = metadata.resultsCount
    }
}

extension OffsetPaginationContext: PaginationContext {
    typealias Metadata = OffsetPaginationMetadata
    
    var isOnFirstPage: Bool {
        currentPage == Self.firstPage
    }

    var hasMorePages: Bool {
        return currentPage <= totalPages
    }
}
//
//
//protocol PaginationStrategy {
//    /// The type that holds pagination state (page numbers, cursors, etc.)
//    associatedtype State: Equatable
//    associatedtype PageParameter
//
//    /// The type of response this strategy can handle
//    associatedtype Response
//
//    /// Initial state when starting pagination
//    var initialState: State { get }
//
//    /// Check if more pages are available
//    func hasMorePages(state: State) -> Bool
//
//    /// Check if currently on the first page
//    func isFirstPage(state: State) -> Bool
//
//    /// Update state after receiving a response
//    func nextState(currentState: State, response: Response) -> State
//
//    /// Extract the page parameter to request
//    func pageParameter(from state: State) -> PageParameter
//}
//
//
//struct OffsetPaginationStrategy: PaginationStrategy {
//    // Configuration
//    let startPage: Int
//    let pageSize: Int?
//
//    init(startPage: Int = 1, pageSize: Int? = nil) {
//        self.startPage = startPage
//        self.pageSize = pageSize
//    }
//
//    // MARK: State Definition
//
//    struct State: Equatable {
//        var currentPage: Int
//        var totalPages: Int
//        var totalResults: Int
//
//        init(currentPage: Int, totalPages: Int, totalResults: Int = 0) {
//            self.currentPage = currentPage
//            self.totalPages = totalPages
//            self.totalResults = totalResults
//        }
//    }
//
//    // MARK: Protocol Implementation
//
//    var initialState: State {
//        State(currentPage: startPage, totalPages: startPage)
//    }
//
//    func hasMorePages(state: State) -> Bool {
//        state.currentPage <= state.totalPages
//    }
//
//    func isFirstPage(state: State) -> Bool {
//        state.currentPage == startPage
//    }
//
//    func nextState(currentState: State, response: OffsetPaginationMetadata) -> State {
//        State(
//            currentPage: response.currentPage + 1,
//            totalPages: response.totalPages,
//            totalResults: response.totalResults
//        )
//    }
//
//    func pageParameter(from state: State) -> Int {
//        state.currentPage
//    }
//}
//
//
////protocol PaginationStrategy {
////    associatedtype State: Equatable
////    associatedtype PageParameter
////}
//
//struct PaginationContextStruct<Strategy: PaginationStrategy> {
//    let strategy: Strategy
//    let state: Strategy.State
//    let loadingState: AsyncLoadingState
//
//    init(strategy: Strategy) {
//        self.strategy = strategy
//        self.state = strategy.initialState
//        self.loadingState = .idle
//    }
//}
//
//protocol PaginationCoordinator {
//    associatedtype Strategy: PaginationStrategy
//    //associatedtype PageParameter
//    //associatedtype Response
////    var strategy: Strategy { get }
////    var state: Strategy.State { get set }
////    var loadingState: AsyncLoadingState { get set }
//    var paginationContext: PaginationContextStruct<Strategy> { get }
//
//    func fetch(_ state: Strategy.State) async throws -> any PaginatedContainer
//    //var fetcher: (Strategy.State) -> any PaginatedContainer { get }
//}
//
//extension PaginatedResponse: PaginatedContainer {
//    var metadata: any OffsetPaginationMetadata {
//
//    }
//
//    var items: [T] {
//        self.items
//    }
//}
//
//@MainActor @Observable
//class NewMediasListViewModel2: @preconcurrency PaginationCoordinator {
////    let strategy = OffsetPaginationStrategy()
////    var state: OffsetPaginationStrategy.State
////
////    var loadingState: AsyncLoadingState
//    var paginationContext = PaginationContextStruct(strategy: OffsetPaginationStrategy())
//
//    let section: NewMediasSection
//
//    var items: [Media] = []
//
//    func fetch(_ state: OffsetPaginationStrategy.State) async throws -> some PaginatedContainer {
//        try await section.dataProvider?.fetch(page: state.currentPage)
//    }
//
//    func fetch() async throws {
//        let items = try await fetch(paginationContext.state).items
//    }
//
//    init(section: NewMediasSection) {
//        self.section = section
//    }
//}
//
//
//final class MediasListPaginationCoordinator: PaginationCoordinator {
//    var strategy = OffsetPaginationStrategy()
//    lazy var state = strategy.initialState
//    var loadingState = AsyncLoadingState.idle
//    var fetcher: (Int) -> PaginatedResponse<Media>
//}
//
//protocol OffsetPaginationMetadata {
//    var currentPage: Int { get }
//    var totalPages: Int { get }
//    var totalResults: Int { get }
//}
//
//
//protocol PaginatedContainer {
//    associatedtype T: Decodable
//    var metadata: OffsetPaginationMetadata { get }
//    var items: [T] { get }
//}


//@MainActor
//class NewMediasListViewModel2: ObservableObject {
//    @Published var medias: [Media] = []
//    @Published var section: NewMediasSection
//    @Published var isLoaded: Bool = false
//
//    private var cancellables = Set<AnyCancellable>()
//    
//    private var currentPage: Int = 1
//    private var totalPages: Int = 1
//    
//    @Published var isLoadingPage: Bool = false
//    
//    var hasMorePages: Bool {
//        return currentPage <= totalPages
//    }
//
//    func fetchMedias() {
//        guard !isLoadingPage, hasMorePages else { return }
//        isLoadingPage = true
//        
//        Task {
//            guard let response = try await section.dataProvider?.fetch(page: currentPage) else { return }
//            if response.page == 1 { medias = [] }
//            medias.append(contentsOf: response.results)
//            totalPages = response.total_pages
//            currentPage += 1
//            isLoaded = true
//            isLoadingPage = false
//        }
////        
////        section.publisherBuilder?(currentPage)
////            .sink { [unowned self] completion in
////                isLoadingPage = false
////                if case .failure(let error) = completion {
////                    print("Error fetching medias: \(error)")
////                }
////            } receiveValue: { [unowned self] response in
////                if response.page == 1 { medias = [] }
////                medias.append(contentsOf: response.results)
////                totalPages = response.total_pages
////                currentPage += 1
////                isLoaded = true
////            }
////            .store(in: &cancellables)
//    }
//    
//    func isLastLoaded(media: Media) -> Bool {
//        media.id == medias.last?.id
//    }
//    
//    init(section: NewMediasSection) {
//        self.section = section
//    }
//
//    deinit {
//        cancellables.forEach { $0.cancel() }
//    }
//}
