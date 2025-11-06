//
//  AsyncImageView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct AsyncImageView: View {
    private let url: URL?
    
    @State private var isHidden: Bool = false
    @State private var isLoaded: Bool = false
    
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    private let placeholder: UIImage?
    
    init(url: URL?, width: CGFloat? = nil, height: CGFloat? = nil, cornerRadius: CGFloat = 0, placeholder: UIImage? = nil) {
        self.url = url
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.placeholder = placeholder
    }
    
    private func createPlaceholderView(error: Bool) -> some View {
        return ZStack {
            if let placeholder {
                Image(uiImage: placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if !error {
                Color.secondary.opacity(0.3)
            } else {
                Color.red.opacity(0.3)
                Image(systemName: "exclamationmark.triangle")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
    
    var body: some View {
        ZStack {
            if let url, !isHidden {
                AsyncImage(url: url, transaction: .init(animation: .default)) { phase in
                    Group {
                        switch phase {
                        case .empty:
                            Color.secondary.opacity(0.3)
                                .shimmering()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .onAppear {
                                    isLoaded = true
                                }
                        case .failure:
                            createPlaceholderView(error: true)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            } else {
                createPlaceholderView(error: false)
            }
        }
        .onAppear {
            isHidden = false
        }
        .onDisappear {
            if !isLoaded {
                isHidden = true
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(cornerRadius)
    }
}
