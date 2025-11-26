//
//  MediaVideoView.swift
//  Movee
//
//  Created on 24.10.2025.
//

import SwiftUI

struct MediaVideoView: View {
    var data: Data

    @State private var isPlayerVisible: Bool = false
    @State private var isPlayerLoading: Bool = false

    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                AsyncImageView(url: data.backdropURL)
                    .aspectRatio(16/9, contentMode: .fill)
                Color.secondary.opacity(0.1)
                if isPlayerLoading {
                    ProgressView()
                        .tint(.white)
                        .controlSize(.extraLarge)
                } else {
                    Image(systemName: "play.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
            }
            .onTapGesture {
                isPlayerVisible = true
                isPlayerLoading = true
            }

            if isPlayerVisible, let youtubeURL = data.youtubeURL {
                WebView(.url(youtubeURL))
                    .onLoadingStateChanged { _, isLoading in
                        isPlayerLoading = isLoading
                    }
                    .aspectRatio(16/9, contentMode: .fit)
                    .opacity(isPlayerLoading ? 0 : 1)
                    .animation(.easeOut, value: isPlayerLoading)
            }
        }
        .clipShape(.rect(cornerRadius: 8))
    }
}
