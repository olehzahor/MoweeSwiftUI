//
//  ClippedImage.swift
//  Movee
//
//  Created by user on 11/25/25.
//

import SwiftUI

struct ClippedImage: View {
    let image: Image
    let contentMode: ContentMode
    
    init(_ image: Image, contentMode: ContentMode = .fill) {
        self.image = image
        self.contentMode = contentMode
    }
    
    var body: some View {
        Color.clear
            .overlay {
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            }
            .clipped()
    }
}

// MARK: - Convenience initializers
extension ClippedImage {
    init(_ name: String, contentMode: ContentMode = .fill) {
        self.init(Image(name), contentMode: contentMode)
    }
    
    init(systemName: String, contentMode: ContentMode = .fill) {
        self.init(Image(systemName: systemName), contentMode: contentMode)
    }
    
    init(uiImage: UIImage, contentMode: ContentMode = .fill) {
        self.init(Image(uiImage: uiImage), contentMode: contentMode)
    }
}
