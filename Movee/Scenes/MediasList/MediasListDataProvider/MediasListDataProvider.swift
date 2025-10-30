//
//  MediasListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation

protocol MediasListDataProvider {
    func fetch(page: Int) async throws -> PaginatedResponse<Media>
}
