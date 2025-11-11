//
//  NewMediasListViewModel.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import Combine
import Foundation

@MainActor @Observable
class NewMediasListViewModel {
    private let section: NewMediasSection
    let dataSource: PagedDataSource<Media>
    
    var title: String {
        section.fullTitle ?? section.title
    }
    
    init(section: NewMediasSection) {
        self.section = section
        self.dataSource = .pageNumber { [section] page in
            guard let dataProvider = section.dataProvider else {
                throw MediasSectionError.noDataProvider
            }
            return try await dataProvider.fetch(page: page)
        }
    }
}
