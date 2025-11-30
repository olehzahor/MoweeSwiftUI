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
    
    @ViewBuilder
    private var errorView: some View {
        if let placeholder {
            ClippedImage(uiImage: placeholder, contentMode: contentMode)
        } else {
            ZStack {
                Color.red.opacity(0.3)
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
    
    @ViewBuilder
    private var placeholderView: some View {
        if url == nil {
            if let placeholder {
                ClippedImage(uiImage: placeholder, contentMode: contentMode)
            } else {
                Color.secondary.opacity(0.3)
            }
        } else {
            Color.secondary.opacity(0.3)
                .loadable()
                .loading(true)
        }
    }
        
    var body: some View {
        AsyncImage(url: url, transaction: .init(animation: .easeOut)) { phase in
            switch phase {
            case .success(let image):
                ClippedImage(image, contentMode: contentMode)
            case .failure:
                errorView
            default:
                placeholderView
            }
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
