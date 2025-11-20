//
//  PagedDataSource+PageNumber.swift
//  Movee
//
//  Created by user on 11/11/25.
//

extension PagedDataSource {
    static func pageNumber(
        loadPage: @escaping (Int) async throws -> PaginatedResponse<Item>
    ) -> PagedDataSource<Item> {
        var currentPage = 1
        var totalPages = 1
        
        return PagedDataSource {
            let response = try await loadPage(currentPage)
            
            let isFirst = currentPage == 1
            currentPage = response.page + 1
            totalPages = response.total_pages
            
            return PageLoadResult(
                items: response.results,
                hasMore: currentPage <= totalPages,
                isFirstPage: isFirst
            )
        } onRefresh: {
            currentPage = 1
            totalPages = 1
        }
    }
}
