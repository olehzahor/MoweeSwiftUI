//
//  NewMediasListViewModel.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import Combine
import Foundation

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
