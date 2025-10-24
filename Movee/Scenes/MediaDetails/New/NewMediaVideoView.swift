//
//  NewMediaVideoView.swift
//  Movee
//
//  Created on 24.10.2025.
//

import SwiftUI

struct NewMediaVideoView: View {
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

    var data: DataModel

    @State private var size: CGSize = .zero
    @State private var isPlayerVisible: Bool = false
    @State private var isPlayerLoading: Bool = false

    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                AsyncImageView(url: data.backdropURL, height: size.width * 9/16)
                    .saveSize(in: $size)
                Color.secondary.opacity(0.1)
                if isPlayerLoading {
                    ProgressView()
                } else {
                    Image(systemName: "play.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
            }
            .onTapGesture {
                isPlayerVisible = true
                isPlayerLoading = true
            }

            if isPlayerVisible, let youtubeURL = data.youtubeURL {
                WebView(.url(youtubeURL)).onLoadingStateChanged { _, isLoading in
                    isPlayerLoading = isLoading
                }
                .opacity(isPlayerLoading ? 0 : 1)
                .animation(.easeOut, value: isPlayerLoading)
            }
        }
        .clipShape(.rect(cornerRadius: 8))
    }
}
