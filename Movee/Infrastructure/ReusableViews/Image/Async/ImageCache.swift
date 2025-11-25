//
//  ImageCache.swift
//  Movee
//
//  Created by user on 11/24/25.
//

import UIKit

actor ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()
    private let session: URLSession

    private init() {
        cache.totalCostLimit = 100 * 1024 * 1024

        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024
        )
        self.session = URLSession(configuration: config)
    }

    func image(for url: URL) async throws -> UIImage {
        let key = url.absoluteString as NSString

        if let cached = cache.object(forKey: key) {
            return cached
        }

        let (data, _) = try await session.data(from: url)

        guard let image = UIImage(data: data) else {
            throw ImageCacheError.invalidImageData
        }

        cache.setObject(image, forKey: key)

        return image
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}

enum ImageCacheError: Error {
    case invalidImageData
}
