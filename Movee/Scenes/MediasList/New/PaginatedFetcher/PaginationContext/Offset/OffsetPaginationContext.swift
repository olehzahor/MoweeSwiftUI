//
//  OffsetPaginationContext.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import Foundation

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
