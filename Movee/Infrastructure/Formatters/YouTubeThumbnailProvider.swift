//
//  YouTubeThumbnailProvider.swift
//  Movee
//
//  Created by user on 5/4/25.
//


import Foundation

/// Provides URLs for YouTube video thumbnails given a YouTube `videoID`.
final class YouTubeThumbnailProvider {
    static let shared = YouTubeThumbnailProvider()
    private init() {}
    
    /// Available thumbnail sizes (see https://developers.google.com/youtube/v3/docs/thumbnails).
    enum Size: String {
        /// Default quality (120×90px)
        case `default`   = "default"
        /// Medium quality (320×180px)
        case mqDefault   = "mqdefault"
        /// High quality (480×360px)
        case hqDefault   = "hqdefault"
        /// Standard definition (640×480px)
        case sdDefault   = "sddefault"
        /// Maximum resolution available
        case maxRes      = "maxresdefault"
    }
    
    /// Returns the URL of the thumbnail image for the given `videoID` and `size`.
    /// - Parameters:
    ///   - videoID: the YouTube video identifier (e.g. `"dQw4w9WgXcQ"`).
    ///   - size: one of the `Size` enum cases. Defaults to `.default`.
    func thumbnailURL(for videoID: String, size: Size = .default) -> URL? {
        // Format: https://img.youtube.com/vi/<videoID>/<size>.jpg
        let urlString = "https://img.youtube.com/vi/\(videoID)/\(size.rawValue).jpg"
        return URL(string: urlString)
    }
    
    /// Returns the standard YouTube watch URL for your video.
    func watchURL(for videoID: String) -> URL? {
        URL(string: "https://www.youtube.com/watch?v=\(videoID)")
    }
    
    /// Returns the embeddable URL for use in webviews or iframes.
    func embedURL(for videoID: String) -> URL? {
        URL(string: "https://www.youtube.com/embed/\(videoID)")
    }
}