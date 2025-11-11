//
//  PaginatedFetcher.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import Foundation

protocol PaginatedFetcher: AnyObject {
    associatedtype Response
    associatedtype Pagination: PaginationContext
        
    var paginationContext: Pagination { get set }
    var loadingState: AsyncLoadingState { get set }
    
    func fetchData(_ context: Pagination) async throws -> Response
    func updatePaginationContext(_ response: Response)
    func handleFirstFetch(_ response: Response)
    func handlePageFetch(_ response: Response)
    func isResponseEmpty(_ response: Response) -> Bool
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
