//
//  AsyncImageView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL?

    let placeholder: UIImage?
    let contentMode: ContentMode

    @State private var loader = ImageLoader()

    private var image: UIImage? {
        url == nil ? placeholder : loader.image
    }
    
    @ViewBuilder
    private var errorView: some View {
        ZStack {
            Color.red.opacity(0.3)
            Image(systemName: "exclamationmark.triangle")
                .font(.title)
                .foregroundColor(.white)
        }
    }
        
    var body: some View {
        ZStack {
            if let image {
                ClippedImage(uiImage: image, contentMode: contentMode)
            }

            if url != nil, loader.image == nil {
                Color.secondary.opacity(0.3)
                    .loadable()
                    .fallible { _, _ in errorView }
            }
        }
        .postponedAnimation(0.1, .default, value: loader.state)
        .loadingState(loader.state)
        .task(id: url) {
            await loader.load(url: url)
        }
    }
    
    init(url: URL?,
         placeholder: UIImage? = nil,
         contentMode: ContentMode = .fill) {
        self.url = url
        self.placeholder = placeholder
        self.contentMode = contentMode
    }
}

#Preview {
    ScrollView {
        VStack {
            Spacer()

            AsyncImageView(url: URL(string: "https://www.themoviedb.org/t/p/w600_and_h900_face/gKY6q7SjCkAU6FqvqWybDYgUKIF.jpg")!)
                .frame(width: 100, height: 150)
            AsyncImageView(url: URL(string: "https://media.themoviedb.org/t/p/w533_and_h300_face/vL5LR6WdxWPjLPFRLe133jXWsh5.jpg")!)
                .aspectRatio(16/9, contentMode: .fill)
                .frame(maxWidth: .infinity)
            AsyncImageView(url: URL(string: "https://media.themoviedb.org/t/p/w533_and_h300_face/vL5LR6WdxWPjLPFRLe133jXWsh5.jpg")!,
                           contentMode: .fit)
                .frame(width: 100, height: 150)

            Spacer()
        }
    }
}
