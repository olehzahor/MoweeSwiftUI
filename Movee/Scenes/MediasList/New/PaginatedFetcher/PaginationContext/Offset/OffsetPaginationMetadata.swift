//
//  OffsetPaginationMetadata.swift
//  Movee
//
//  Created by user on 11/11/25.
//

protocol OffsetPaginationMetadata {
    var currentPage: Int { get }
    var totalPages: Int { get }
    var resultsCount: Int { get }
}

