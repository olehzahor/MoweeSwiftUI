//
//  MediaDetailsRepositoryProtocol.swift
//  Movee
//
//  Created by Oleh on 21.10.2025.
//

import Foundation

protocol MediaDetailsRepositoryProtocol {
    func fetchMedia(_ identifier: MediaIdentifier) async throws -> Media
    func fetchRelated(_ identifier: MediaIdentifier) async throws -> [Media]
    func fetchCredits(_ identifier: MediaIdentifier) async throws -> [MediaPerson]
    func fetchReviews(_ identifier: MediaIdentifier) async throws -> [Review]
    func fetchVideos(_ identifier: MediaIdentifier) async throws -> [Video]
    func fetchCollection(_ media: Media?) async throws -> [Media]
}
