//
//  NewMediaVideoView.swift
//  Movee
//
//  Created on 24.10.2025.
//

import SwiftUI

struct NewMediaVideoView: View {
    var data: DataModel

    @State private var isPlayerVisible: Bool = false
    @State private var isPlayerLoading: Bool = false

    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                AsyncImageView(url: data.backdropURL)
                Color.secondary.opacity(0.1)
                if isPlayerLoading {
                    ProgressView()
                        .tint(.white)
                        .controlSize(.extraLarge)
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
        .scaledToFillAspectRatio(16/9)
        .clipShape(.rect(cornerRadius: 8))
    }
}
