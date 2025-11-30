//
//  MediasListDataProvider.swift
//  Movee
//
//  Created by Oleh on 30.10.2025.
//

import Foundation
import Factory

protocol MediasListDataProvider {
    func fetch(page: Int) async throws -> PaginatedResponse<Media>
}

extension MediasListDataProvider {
    static var networkClient: NetworkClient {
        Container.shared.networkClient()
    }
}
