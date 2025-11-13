//
//  DataModel.swift
//  Movee
//
//  Created by Oleh on 27.10.2025.
//


import SwiftUI

extension MediaVideoView {
    struct DataModel {
        var title: String
        var backdropURL: URL?
        var videoKey: String?

        var youtubeURL: URL? {
            guard let videoKey else { return nil }
            return YouTubeURLProvider.shared.embedURL(for: videoKey)
        }

        static var placeholder = Self(title: .placeholder(.short))

        init(title: String, backdropURL: URL? = nil, videoKey: String? = nil) {
            self.title = title
            self.backdropURL = backdropURL
            self.videoKey = videoKey
        }

        init(video: Video) {
            self.title = video.name
            self.backdropURL = video.thumbnailURL
            self.videoKey = video.key
        }
    }
}