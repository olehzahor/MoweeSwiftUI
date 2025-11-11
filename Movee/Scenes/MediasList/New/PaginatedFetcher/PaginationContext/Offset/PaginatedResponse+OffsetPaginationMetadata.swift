//
//  PaginatedResponse+OffsetPaginationMetadata.swift
//  Movee
//
//  Created by user on 11/11/25.
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
